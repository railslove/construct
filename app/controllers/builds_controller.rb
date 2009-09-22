class BuildsController < ApplicationController
  before_filter :project
  before_filter :build, :only => [:rebuild, :show]
  
  def index
    @latest = @project.builds.first
    @previous_builds = @project.builds.before(@latest)
    @commit = @latest.commit
  end
  
  def show
    @previous_builds = @project.builds.before(@build)
  end
  
  def rebuild
    @new_build = @build.rebuild
    flash[:notice] = "Build #{@build.commit.sha} rebuilding for #{@build.project.name}"
    redirect_to [@project, @new_build]
  end
  
  private
  
  def project
    @project = Project.find(params[:project_id])
  end
  
  def build
    @build = Build.find(params[:id])
  end
end
