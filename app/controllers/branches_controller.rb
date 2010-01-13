class BranchesController < ApplicationController
  before_filter :project
  
  def index
    @branches = @project.branches.all(:include => { :builds => :commit })
  end
  
  def build_latest
    @branch = Branch.find_by_name(params[:id])
    @branch.build_latest!
    flash[:notice] = "Building latest for #{@branch.name}"
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "The branch you were looking for does not exist"
  ensure
    redirect_to project_branch_builds_path(@project, @branch)
  end
  
  private
  
  def project
    @project = Project.find_by_permalink(params[:project_id])
  end
end
