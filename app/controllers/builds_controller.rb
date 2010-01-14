class BuildsController < ApplicationController
  before_filter :project
  before_filter :branch
  before_filter :build, :only => [:rebuild, :show]
  
  def index
    @build = @branch ? @branch.builds.first : @project.builds.first
    other_builds
    @commit = @build.commit
  end
  
  def show
    other_builds
  end
  
  def rebuild
    @new_build = @build.rebuild
    if @new_build
      flash[:notice] = "Build #{@build.commit.short_sha} rebuilding for #{@build.project.name}"
    else
      flash[:error] = "There is already a build in progress for #{@build.commit.short_sha}"
      @new_build = @build
    end
    redirect_to [@project, @branch, @new_build].flatten
  end
  
  private
  
  def project
    @project = Project.find_by_permalink(params[:project_id])
  end
  
  def branch
    @branch = @project.branches.find_by_name(params[:branch_id])
  end
  
  def build
    @build = Build.find(params[:id])
  end
  
  def other_builds
    @before_builds = (@branch || @project).builds.before(@build)
    @after_builds  = (@branch || @project).builds.after(@build)
  end
end
