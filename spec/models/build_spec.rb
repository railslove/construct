require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Build do
  describe GithubBuild do
    before do
      @payload = payload("github")
      @build = GithubBuild.setup(@payload).start
      @project = Project.find_by_name(@payload["repository"]["name"])
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
  end
  
  describe CodebaseBuild do
    before do
      @payload = private_payload("codebase")
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
  end
end
