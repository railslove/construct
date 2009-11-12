require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do
  before do
    @github = payload(:"construct-success")
    Project.make(:by_star)
  end
  
  it "should accept github payload" do
    assert_difference "Build.count" do
      post :github, :payload => @github  
    end
  end

  it "should generate correct params" do
    { :get => "/projects/construct/branches/1.2.3/builds" }.should route_to({ :controller => "builds", :action => "index", :project_id => "construct", :branch_id => "1.2.3" })
  end
  
  it "should generate correct params" do
    { :get => "/projects/de_structa/branches/other_branch/builds" }.should route_to({ :controller => "builds", :action => "index", :project_id => "de_structa", :branch_id => "other_branch" })
  end
  
end
