# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def header_and_title
    @title = ""
    path = url_for(params)
    logger.info(path)
    @header, @title = if path =~ /^\/projects\/(.*?)\/builds$/
      ["#{link_to("projects", projects_path)} / #{@project.name}", @title]
    elsif path =~ /^\/projects$/
      ["projects", "projects"]
    elsif path =~ /^\/projects\/(.*?)\/builds\/(.*?)$/
      ["#{link_to("projects", projects_path)} / #{link_to(@project.name, @project)} / #{link_to("builds", project_builds_path(@project))} / #{@build.commit.short_sha} - ##{@build.number}", @title]
    end
    
    @title += " | construct"
  end
end
