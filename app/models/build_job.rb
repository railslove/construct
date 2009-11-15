class BuildJob < Struct.new(:build_id, :payload)
  attr_accessor :build, :project, :clone_url, :build_directory

  def setup
    self.build.run_output ||= ""
    self.build.run_errors ||= ""
    build.update_status("setting up repository")
    repository = payload["repository"]
    self.project = Project.find_by_name(repository["name"])
    
    branch = build.branch
    self.build_directory = File.join(project.build_directory, branch.name)
    FileUtils.mkdir_p(build_directory)
    # Even though with chdir inside the methods, it's better to be safe than sorry.
    
    self.clone_url = repository["clone_url"] # For codebase repositories
    self.clone_url ||= "git@#{build.site}:#{repository["owner"]["name"]}/#{repository["name"]}.git" if repository["private"] # private repositories on github
    self.clone_url ||= "git://#{build.site}/#{repository["owner"]["name"]}/#{repository["name"]}.git" # All the rest
    # Will have to have different directories for the different branches at one point.
    
    if !File.exist?(build_directory) 
      clone_repo
    elsif !File.exist?(File.join(build_directory, ".git"))
      # If the clone initially failed it will create a blank directory, remove that directory.
      FileUtils.rm_rf(build_directory)
      clone_repo
    else
      Dir.chdir(build_directory) do
        `git pull origin master`
        checkout_commit
      end
    end
  
  end
  
  def perform
    begin
      setup
      SystemTimer.timeout_after(project.timeout) do
        Dir.chdir(build_directory) do
          @build.update_status("running the build")
          POpen4::popen4(project.instructions) do |stdout, stderr, stdin, pid|
            until stdout.eof? && stderr.eof?
              @build.run_output += stdout.read_nonblock(1024) unless stdout.eof?       
              @build.run_errors += stderr.read_nonblock(1024) unless stderr.eof?
              @build.save!
            end
          end
          build.update_status($?.success? ? "success" : "failed")
        end
      end
    
      # To ensure we're not running builds for the one project at the same time
      # We will start running a build after one has finished.
      # There is code also in build.rb (Build#start) that stops this.
      if build = project.builds.after(@build).last
        build.start
      end
    
      build
    rescue SignalException
      build.update_status("stalled")
      build.save!
    ensure
      return build
    end
  end
  
  # Helper method for running steps that will follow the same ol' pending, succeed/failed chain of events.
  def run_step(command, pending="pending", success="success", failure="failed")
    POpen4::popen4(command) do |stdout, stderr, stdin, pid|
      until stdout.eof? && stderr.eof?
        @build.run_output << stdout.read_nonblock(1024) unless stdout.eof?
        @build.run_errors << stderr.read_nonblock(1024) unless stderr.eof?
        @build.save!
      end
    end
    if $?.success? 
      @build.update_status(success)
    else 
      @build.update_status(failure)
    end
    $?.success?
  end
  
  def build
    @build ||= Build.find(build_id)
  end
  
  def checkout_commit
    branch = build.branch.name
    output = ""
    
    POpen4::popen4("git checkout . && git checkout origin/#{branch} -b #{branch}") do |stdout, stderr, stdin, pid|
      until stdout.eof? && stderr.eof?
        @build.run_output << stdout.read_nonblock(1024) unless stdout.eof?
        @build.run_errors << stderr.read_nonblock(1024) unless stderr.eof?
        @build.save!
      end
    end
    
    command = build.commit ? "git checkout -f #{build.commit.sha}" : "git checkout -f -b #{build.branch} origin/#{build.branch}"
    POpen4::popen4(command) do |stdout, stderr, stdin, pid|
      until stdout.eof? && stderr.eof?
        @build.run_output << stdout.read_nonblock(1024) unless stdout.eof?
        @build.run_errors << stderr.read_nonblock(1024) unless stderr.eof?
        @build.save!
      end
    end
    
    if $?.success?
      @build.update_status("checked out successfully")
    else
      if output =~ /already exists$/
        @build.update_status("branch already exists")
      else
        @build.update_status("branch checkout failed")
      end
    end
    $?.success?
  end
  
  def clone_repo
    run_step("git clone #{clone_url} #{build_directory.inspect}", "setting up repository", "set up repository", "repository setup failed")
  end
end
