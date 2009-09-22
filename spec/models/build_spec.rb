require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Build do
  describe "Github" do
    before do
      @github = payload(:github)
      @project = Project.make(:by_star)
      @build = Build.new
    end
    
    subject { BuildJob.new(@build, @github).perform }
  
    it "should succeed" do
      p @build.output
      should be_successful
    end
  
    it "should fail" do
      @project.instructions = "do_the_impossible"
      @project.save!
      
      should_not be_successful      
    end
  end
  
  
end
