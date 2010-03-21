class ProjectsController < ApplicationController
  
  before_filter :project, :only => [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate, :only => [:github, :codebase]
  
  def index
    respond_to do |format|
      format.html do
        @projects = Project.all(:include => [{ :builds => :commit }, :commits])
      end
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
  
  def destroy
    project_name = @project.name
    @project.destroy
    flash[:notice] = "OMG! you just nuked the entire #{project_name} project."
    redirect_to root_url
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
    branches = Branch.all(:order => "project_id ASC, name ASC")
    projects_xml = Nokogiri::XML::Builder.new do |xml|
      xml.Projects do
        branches.each do |branch|
          latest_build = branch.builds.first
          xml.Project(:name            => branch.project.name + " (#{branch.name})",
                      :category        => latest_build.branch.name,
                      :lastBuildStatus => latest_build.failed? ? "Failure" : "Success",
                      :lastBuildLabel  => latest_build.commit.short_sha,
                      :lastBuildTime   => latest_build.created_at.xmlschema,
                      :activity        => latest_build.finished? ? "Sleeping" : "Building",
                      :webUrl          => project_branch_builds_url(branch.project.permalink, branch.name))
        end
      end
    end.to_xml
    render :xml => projects_xml
  end
  
end