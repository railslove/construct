require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuildJob do
  before do
    @payload = payload("github")
    @build = GithubBuild.setup(@payload)
    @project = Project.find_by_name(@payload["repository"]["name"])
  end
  
  describe BuildJob, "setup" do
    it "should clone the repo if it doesn't exist" do
      File.exist?(@project.build_directory).should be_false
      @build_job = BuildJob.new(@build.id, @payload)
      @build_job.setup
      File.exist?(@project.build_directory).should be_true
    end
  end

  describe BuildJob, "checking out branches" do
    def setup_build(payload)
      @build = GithubBuild.setup(payload)
      @project = Project.find_by_name(payload["repository"]["name"])
      @build_job = BuildJob.new(@build.id, payload)
      @build_job.setup
      @build.reload
    end
  
    describe BuildJob, "with standard payload" do
      before do
        setup_build(payload("github"))
      end
  
      it "should just ignore the branch if it already exists" do
        @build.status.should eql("branch master already exists, proceeding")
      end
  
    end

    describe BuildJob, "with alternate branch payload from Github" do
      before do
        setup_build(payload("github_branch"))
      end
  
      it "should be able to check out the branch" do
        @build.status.should eql("checked out remote branch thomas")
      end
  
    end
  end
end