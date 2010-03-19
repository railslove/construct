class BranchesController < ApplicationController
  
  before_filter :find_project
  
  def index
    @branches = @project.branches.all(:include => { :builds => :commit })
  end
  
  def edit
    @branch = @project.branches.find_by_name(params[:id])
  end
  
  def update
    
  end
  
  def build_latest
    @branch = @project.branches.find_by_name(params[:id])
    @branch.build_latest!
    flash[:notice] = "Building latest for #{@branch.name}"
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "The branch you were looking for does not exist"
  ensure
    redirect_to project_branch_builds_path(@project, @branch)
  end
  
  def destroy
    branch = @project.branches.find_by_name(params[:id])
    branch.destroy
    flash[:notice] = "Branch deleted"
    redirect_to project_path(@project)
  end
  
  private
  
  def find_project
    @project = Project.find_by_permalink(params[:project_id])
  end

end
