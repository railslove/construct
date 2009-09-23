class BuildJob < Struct.new(:build_id, :payload)
  def perform
    # Why must we do this?
    build = Build.find(build_id)
    repository = payload["repository"]
    project = Project.find_by_name(repository["name"])
    if !project
      puts "There is no project."
      exit!
    end
    
    build_directory = "/data/builds/#{repository["name"]}"
    build.update_attribute("status", "setting up repository")
    # Will have to have different directories for the different branches at one point.
    if !File.exist?(File.join(build_directory, ".git"))
      clone_url = "git@github.com:#{repository["owner"]["name"]}/#{repository["name"]}"
      `git clone #{clone_url} #{build_directory}`
    end
     
    Dir.chdir(build_directory) do
      `git pull origin master`
      build.update_attribute("status", "running the build")
      build.output = `#{project.instructions}`
      build.update_attribute("status", $?.success? ? "success" : "failed")
      # Just to ensure...
      build.save!
    end
    build
  end
end
