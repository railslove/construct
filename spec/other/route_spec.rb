require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController, "Custom routes" do
  include ActionController::Assertions::RoutingAssertions
  
  def app
    @app ||= ActionController::Integration::Session.new
  end
  
  it "should accept dots in project paths" do
    generated_path = lambda { app.project_path("1.2.3") }
    generated_path.should_not raise_error
    generated_path.call.should eql("/projects/1.2.3")
  end
  
  it "should accept dots in branches paths" do
    generated_path = lambda { app.project_branch_path("construct", "1.2.3") }
    generated_path.should_not raise_error
    generated_path.call.should eql("/projects/construct/branches/1.2.3")
  end
  
  it "should generate correct params" do
    { :get => "/projects/construct/branches/1.2.3/builds" }.should route_to("somewhere")
  end
  
end