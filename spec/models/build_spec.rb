require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Build do
  describe GithubBuild do
    before do
      @successful_payload = payload("construct-success")
      @other_successful_payload = payload("construct-success-2")
      @build = GithubBuild.setup(@successful_payload).start
      @other_build = GithubBuild.setup(@other_successful_payload).start
      @project = Project.find_by_name(@successful_payload["repository"]["name"])
    end
    subject { BuildJob.new(@build, @successful_payload).perform }

    it "should succeed" do
      should be_successful
    end

    it "should fail" do
      @project.instructions = @build.instructions = "do_the_impossible"
      [@project, @build].each(&:save!)
      BuildJob.new(@build, @successful_payload).perform
      @build.should_not be_successful
    end
  
    it "should be able to rebuild" do
      Delayed::Job.delete_all
      assert_difference "Build.count" do
        @build.rebuild
      end
    end
    
    it "should be waiting, not building if there is a build already for this project" do
      @other_build.status.should eql("queued")
    end
  end
  
  describe CodebaseBuild do
    before do
      @payload = payload("docjockey")
      @build = CodebaseBuild.setup(@payload).start
      @project = Project.find_by_name(@payload["repository"]["name"])
      @project.instructions = @build.instructions = "cp config/database.yml.example config/database.yml && rake db:create:all --trace && git submodule update --init && RAILS_ENV=test rake gems:install db:migrate db:test:prepare spec features --trace"
      @project.save!
      @build.save!
    end
  
    subject { BuildJob.new(@build, @payload).perform }

    it "should succeed" do
      should be_successful
    end

    it "should fail" do
      @project.instructions = @build.instructions = "do_the_impossible"
      [@project, @build].each(&:save!)
      BuildJob.new(@build, @payload).perform 
      @build.should_not be_successful
    end
  
    it "should be able to rebuild" do
      Delayed::Job.delete_all
      assert_difference "Build.count" do
        @build.rebuild
      end
    end
    
    it "should not be able to run two builds for the same project at the same time" do
      
    end
  end
  
  describe Build do
    it "should raise an error if setup is attempted" do
      lambda { Build.setup(@payload) }.should raise_error("Setup must be called on a subclass of Build (GithubBuild or CodebaseBuild)")
    end
    
  end
end

describe "Pharmmd" do
  before do
    @payload = payload("private-pharmmd")
    @build = GithubBuild.setup(@payload).start
    @project = Project.find_by_name(@payload["repository"]["name"])
    @project.instructions = @build.instructions = "rake gems:install RAILS_ENV=test && rake db:migrate spec RAILS_ENV=test && rake gems:install RAILS_ENV=cucumber && rake db:migrate cucumber:ok RAILS_ENV=cucumber CUCUMBER_FORMAT=\"progress --no-color\""
    @project.save!
    @build.save!
    
  end

  subject { BuildJob.new(@build, @payload).perform }
  it "should build" do
    should be_successful
  end
end
