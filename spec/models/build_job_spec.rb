require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuildJob do
  def setup_build(payload)
    @payload   = payload
    @build     = GithubBuild.setup(@payload)
    @project   = Project.find_by_name(@payload["repository"]["name"])
    @build_job = BuildJob.new(@build.id, @payload)
    @build_job.setup
    @build.reload
  end
  
  before do
    setup_build(payload("construct-success"))
  end
  
  describe "#setup" do
    it "should clone the repo if it doesn't exist" do
      @build_job = BuildJob.new(@build.id, @payload)
      @build_job.setup
      File.exist?(@build_job.build_directory).should be_true
    end
    
    it "sets up the project's clone url" do
      @project.clone_url.should be_blank
      @build_job.setup
      @project.reload
      @project.clone_url.should_not be_blank
    end
  end

  describe "checking out branches" do  
    describe "with standard payload" do
      before do
        setup_build(payload("construct-success"))
      end
  
      it "should just ignore the branch if it already exists" do
        @build.status.should eql("checked out successfully")
      end
  
    end

    describe "with alternate branch payload from Github" do
      before do
        setup_build(payload("construct-success-branch"))
      end
  
      it "should be able to check out the branch" do
        @build.status.should eql("checked out successfully")
      end
  
    end
  end
  
  describe "#perform" do
    context "timing out" do
      before do
        setup_build(payload("construct-success"))
        @build_job.build.project.timeout = 2.seconds
      end
    
      it "sets the build status to 'stalled' if the job takes more than the timeout" do
        @build_job.build.project.instructions = "sleep 1000"
        @build_job.build.project.save
        @build_job.perform.status.should == "stalled"
      end
    
      it "executes the build normally if the timeout is not reached" do
        @build_job.build.project.instructions = "true"
        @build_job.build.project.save
        @build_job.perform.status.should == "success"        
      end
    end
  end
end