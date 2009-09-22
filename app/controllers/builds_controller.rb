class BuildsController < ApplicationController
  before_filter :project
  
  def index
    @latest = @project.builds.first
    @builds = @project.builds[1..-1]
  end
  
  private
  
  def project
    @project = Project.find(params[:project_id])
  end
end
