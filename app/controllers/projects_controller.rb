class ProjectsController < ApplicationController
  before_filter :project, :only => [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate, :only => [:github, :codebase, :index]
  def index
    @projects = Project.all(:include => [{ :builds => :commit }, :commits])
    respond_to do |format|
      format.html
      format.xml { render_xml }
    end
  end
  
  def show
    redirect_to @project.branches.many? ? project_branches_path(@project) : project_builds_path(@project)
  end
  
  def update
    if @project.update_attributes(params[:project])
      flash[:success] = "Project has been updated."
      redirect_to project_path
    else
      flash[:error] = "Project could not be updated."
      render :action => "edit"
    end
  end
  
  def github
    GithubBuild.setup(JSON.parse(params[:payload])).start
    render :nothing => true
  end
  
  def codebase
    CodebaseBuild.setup(JSON.parse(params[:payload])).start
    render :nothing => true
  end
  
  private
  
  def project
    @project = Project.find_by_permalink(params[:id])
  end
  
  def render_xml
    projects_xml = Nokogiri::XML::Builder.new do |xml|
      xml.Projects {
        for project in @projects
          xml.Project(:name            => project.name,
                      :category        => project.builds.last.branch.name,
                      :lastBuildStatus => project.builds.last.status,
                      :lastBuildLabel  => project.builds.last.commit.short_sha,
                      :lastBuildTime   => project.builds.last.created_at,
                      :webUrl          => project_url(project))
        end
      }
    end.to_xml
    render :xml => projects_xml
  end
end