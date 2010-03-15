class BuildJob < Struct.new(:build_id, :payload)
  attr_accessor :build, :project, :branch, :build_directory

  def setup
    self.payload = JSON.parse(payload) if payload.is_a?(String)
    self.build.run_output ||= ""
    self.build.run_errors ||= ""
    build.update_status("setting up repository")
    repository = payload["repository"]
    self.project = Project.find_by_name(repository["name"])
    self.project.clone_url ||= repository["clone_url"] # For codebase repositories
    self.project.clone_url ||= "git@#{build.site}:#{repository["owner"]["name"]}/#{repository["name"]}.git" if repository["private"] # private repositories on github
    self.project.clone_url ||= "git://#{build.site}/#{repository["owner"]["name"]}/#{repository["name"]}.git" # All the rest
    self.project.save!
    
    self.branch = build.branch
    self.build_directory = File.join(project.build_directory, branch.name)
    
    unless File.exist?(File.join(build_directory, ".git"))
      FileUtils.rm_rf(build_directory)
      clone_repo
    end
    checkout_commit
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
      if build = project.builds.after(@build).last
        build.start
      end
    
      build
    rescue SignalException
      @build.update_status("stalled")
      @build.save!
    ensure
      # Notifier.deliver_build(@build)
      return @build
    end
  end
  
  # Helper method for running steps that will follow the same ol' pending, succeed/failed chain of events.
  def run_step(command, pending="pending", success="success", failure="failed")
    POpen4::popen4(command) do |stdout, stderr, stdin, pid|
      until stdout.eof? && stderr.eof?
        p @build.run_output << stdout.read_nonblock(1024) unless stdout.eof?
        p @build.run_errors << stderr.read_nonblock(1024) unless stderr.eof?
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
    Dir.chdir(build_directory) do
      `git fetch origin`
      `git checkout -f #{build.commit.sha}`
    end
  end
  
  def clone_repo
    run_step("git clone #{project.clone_url} #{build_directory.inspect}", "setting up repository", "set up repository", "repository setup failed")
  end
end
