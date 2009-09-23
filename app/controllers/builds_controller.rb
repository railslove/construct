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
    if @new_build.errors.empty?
      flash[:notice] = "Build #{@build.commit.short_sha} rebuilding for #{@build.project.name}"
    else
      flash[:error] = "Build #{@build.commit.short_sha} could not be built: #{@new_build.errors.full_messages.to_sentence}"
      @new_build.destroy
      @new_build = @build
    end
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
