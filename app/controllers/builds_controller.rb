class BuildsController < ApplicationController
  before_filter :project
  
  def index
    @latest = @project.builds.first
    @previous_builds = @project.builds.all(:conditions => ["created_at < ?", @latest.created_at])
    @commit = @latest.commit
    @builds = @project.builds[1..-1]
  end
  
  private
  
  def project
    @project = Project.find(params[:project_id])
  end
end
