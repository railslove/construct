class ProjectsController < ApplicationController
  before_filter :project, :only => [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate
  def index
    @projects = Project.all
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
  
end