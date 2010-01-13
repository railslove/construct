require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::ProjectsController do
  it "access blocked off to anonymous users" do
    get 'index'
    flash[:error].should eql("You must be logged in to access this area.")
    response.should redirect_to(login_path)
  end
  
end