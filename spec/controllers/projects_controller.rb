require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do
  before do
    @github = payload(:github)
    Project.make(:by_star)
  end
  
  it "should accept github payload" do
    assert_difference "Build.count" do
      post :receive, :payload => @github  
    end
  end

end
