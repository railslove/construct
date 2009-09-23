require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Build do
  ["Github", "Codebase"].each do |site|
    
    describe site do
      before do
        @payload = payload(site.downcase) || private_payload(site.downcase)
        p @payload
        @build = "#{site}Build".constantize.start(@payload)
        @project = Project.find_by_name(@payload["repository"]["name"])
      end
    
      subject { BuildJob.new(@build, @payload).perform }
      
      it "should have a directory" do
        File.exist?(@project.build_directory).should be_true
      end
  
      it "should succeed" do
        should be_successful
      end
  
      it "should fail" do
        @project.instructions = "do_the_impossible"
        @project.save!
        should_not be_successful
      end
    
      it "should be able to rebuild" do
        assert_difference "Build.count" do
          @build.rebuild
        end
      end
    end
  end
end
