require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper
  

  it "should link to the right page" do
    pending
    params = HashWithIndifferentAccess.new(:controller => "projects", :action => "index")
    header_and_title
    @header.should eql("projects")
    @title.should eql("blah")
  end
  
end