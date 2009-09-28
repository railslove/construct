require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuildJob do
  before do
    @payload = payload("construct-success")
    @build = GithubBuild.setup(@payload)
    @project = Project.find_by_name(@payload["repository"]["name"])
  end
  
  describe BuildJob, "setup" do
    it "should clone the repo if it doesn't exist" do
      @build_job = BuildJob.new(@build.id, @payload)
      @build_job.setup
      File.exist?(@build_job.build_directory).should be_true
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
        setup_build(payload("construct-success"))
      end
  
      it "should just ignore the branch if it already exists" do
        @build.status.should eql("checked out successfully")
      end
  
    end

    describe BuildJob, "with alternate branch payload from Github" do
      before do
        setup_build(payload("construct-success-branch"))
      end
  
      it "should be able to check out the branch" do
        @build.status.should eql("checked out successfully")
      end
  
    end
  end
end