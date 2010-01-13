require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Branch do
  before do
    @successful_payload = payload("construct-success")
    @build = GithubBuild.setup(@successful_payload).start
    @project = Project.find_by_name(@successful_payload["repository"]["name"])
  end
  
  describe "build_latest!" do
    it "checks out the latest and builds that" do
      @project.builds.count.should eql(1)
      Dir.chdir(File.join(@project.build_directory, @build.branch.name)) do
        p `git checkout master && echo 'text' > somefile.txt && git add . && git commit -m "Added some file"`
        @project.branches.find_by_name("master").build_latest!
        @project.reload
        @project.builds.count.should eql(2)
        @project.builds.first.commit.sha.should_not eql(@project.builds.last.commit.sha)
        `git reset HEAD --hard`
      end
      
    end
  end
end
