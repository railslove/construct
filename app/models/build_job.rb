class BuildJob < Struct.new(:build, :payload)
  def perform
    repository = payload["repository"]
    project = Project.find_by_name(repository["name"])
    if !project
      puts "There is no project."
      exit!
    end
    
    build_directory = "#{RAILS_ROOT}/builds/#{repository["name"]}"
    FileUtils.mkdir_p(build_directory)
    build.update_attribute("status", "setting up repository")
    # Will have to have different directories for the different branches at one point.
    if !File.exist?(build_directory)
      clone_url = repository["url"].gsub(/^http/, 'git')
      `git clone #{clone_url} #{build_directory}`
    end
     
    Dir.chdir(build_directory) do
      `git pull`
      build.update_attribute("status", "running the build")
      build.output = `#{project.instructions}`
      build.update_attribute("status", $?.success? ? "success" : "failed")
      # Just to ensure...
      build.save!
    end
    build
  end
end
