class BuildJob < Struct.new(:build_id, :payload)
  attr_accessor :build, :project, :clone_url, :build_directory
  def setup
    self.build = Build.find(build_id)
    repository = payload["repository"]
    self.project = Project.find_by_name(repository["name"])
    
    branch = build.branch
    self.build_directory = File.join(project.build_directory, branch.name)
    FileUtils.mkdir_p(build_directory)
    # Even though with chdir inside the methods, it's better to be safe than sorry.
    
    self.clone_url = repository["clone_url"] # For codebase repositories
    self.clone_url ||= "git@#{build.site}:#{repository["owner"]["name"]}/#{repository["name"]}.git" if repository["private"] # private repositories on github
    self.clone_url ||= "git://#{build.site}##{repository["owner"]["name"]}/#{repository["name"]}.git" # All the rest
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
    setup
    Dir.chdir(build_directory) do
      @build.update_attribute("status", "running the build")
      @build.stdout = ""
      @build.stderr = ""
      puts `pwd`
      POpen4::popen4(project.instructions) do |stdout, stderr, stdin, pid|
        @build.stdout << stdout.read.strip
        @build.stderr << stderr.read.strip
      end
      
      @build.update_attribute("status", $?.success? ? "success" : "failed")
      # Just to ensure that everything is updated.
      @build.save!
      # To ensure we're not running builds for the one project at the same time
      # We will start running a build after one has finished.
      # There is code also in build.rb (Build#start) that stops this.
      if build = project.builds.after(@build).last
        build.start
      end
    end
    @build
  end
  
  # Helper method for running steps that will follow the same ol' pending, succeed/failed chain of events.
  def run_step(command, pending="pending", success="success", failure="failed")
    POpen4::popen4(command) do |stdout, stderr, stdin, pid|
      @build.stderr = stderr.read
      @build.stdout = stdout.read
    end
    if $?.success? 
      @build.update_attribute(:status, success)
    else 
      @build.update_attribute(:status, failure)
    end
    $?.success?
  end
  
  def checkout_commit
    branch = build.branch.name
    output = ""
    
    POpen4::popen4("git checkout origin/#{branch} -b #{branch}") do |stdout, stderr, stdin, pid|
      output << stdout.read.strip
      output << stderr.read.strip
    end
    
    command = build.commit ? "git checkout #{build.commit.sha}" : "git checkout origin/#{build.branch} -b #{build.branc}"
    POpen4::popen4(command) do |stdout, stderr, stdin, pid|
      output << stdout.read.strip
      output << stderr.read.strip
    end
    
    if $?.success?
      @build.update_attribute(:status, "checked out successfully")
    else
      if output =~ /already exists$/
        @build.update_attribute(:status, "branch already exists")
      else
        @build.update_attribute(:status, "branch checkout failed")
      end
    end
    $?.success?
  end
  
  def clone_repo
     run_step("git clone #{clone_url} #{build_directory}", "setting up repository", "set up repository", "repository setup failed")
   end
end
