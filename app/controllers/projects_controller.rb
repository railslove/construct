class ProjectsController < ApplicationController
  before_filter :project, :only => [:show, :edit, :update, :destroy]
  def index
    @projects = Project.all
  end
  
  def show
    redirect_to project_builds_path(@project)
  end
  
  def receive
    Build.start(JSON.parse(params[:payload]))
    render :nothing => true
  end
  
  private
  
  def project
    @project = Project.find(params[:id])
  end
  
end