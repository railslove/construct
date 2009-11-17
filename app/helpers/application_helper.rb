# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def header_and_title
    @title = ""
    path = url_for(params)
    logger.info(path)
    # Whilst in development, it will be eaiser to add elsifs than change this if.
    @header, @title = if !path
      
    elsif path =~ /^\/projects\/(.*?)\/branches\/(.*?)\/builds$/
      ["#{link_to("projects", projects_path)} / #{link_to(@project.name, project_path(@project))} / #{link_to("branches", project_path(@project))} / #{@branch.name} / builds", "builds | #{@branch.name} | #{@project.name}"]
    elsif path =~ /^\/projects\/(.*?)\/builds$/
      ["#{link_to("projects", projects_path)} / #{@project.name} / builds", "builds | #{@project.name}"]
    elsif path =~ /^\/projects\/(.*?)\/branches$/
      ["#{link_to("projects", projects_path)} / #{@project.name} / branches", "branches | #{@project.name}"]
    elsif path =~ /^\/projects$/
      ["projects", "projects"]
    elsif path =~ /^\/projects\/(.*?)\/builds\/(.*?)$/
      ["#{link_to("projects", projects_path)} / #{link_to(@project.name, @project)} / #{link_to("builds", project_builds_path(@project))} / #{@build.commit.short_sha} - ##{@build.number}", "Build ##{@build.number} - #{@build.commit.short_sha}"]
    elsif path =~ /^\/projects\/(.*?)\/edit$/
      ["#{link_to("projects", projects_path)} / #{link_to(@project.name, @project)}", "Editing Project"]
    elsif path =~ /^\/setup\/github$/
      ["github / #{link_to "setup", root_path}", "setup | github"]
    elsif path =~ /^\/setup\/codebase$/
      ["codebase / #{link_to "setup", root_path}", "setup | codebase"]
    else ["", ""]
    end
    
    @title += " | construct"
  end
  
  def color_format(text)
    text.to_s.gsub("\e[0m", '</span>').
      gsub(/\e\[(3[1-7]|90)m(?:\e\[(1)m)?/) { "<span class=\"color#{$2 || $1}\">" }
  end
end
