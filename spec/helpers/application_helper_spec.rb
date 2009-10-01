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
  
  
  it "should correctly colour the text" do
    path = "#{RAILS_ROOT}/spec/fixtures/colour/sample_stdout.html"
    File.open(path, "w+") do |f|
      f.write "<link rel='stylesheet' href='style.css'>"
      f.write "<pre>"
      f.write color_format(File.read("#{RAILS_ROOT}/spec/fixtures/colour/sample_stdout"))
      f.write "</pre>"
    end
    `open #{path}`
  end
end