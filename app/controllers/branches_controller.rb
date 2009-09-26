class BranchesController < ApplicationController
  before_filter :project
  
  def index
    @branches = @project.branches.all(:include => { :builds => :commit })
  end
  
  private
  
  def project
    @project = Project.find_by_permalink(params[:project_id])
  end
end
