require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper
    
  
  class TestView < ActionView::Base
    include ApplicationHelper
    
    def controller=(controller)
      @controller = controller.new
      @controller.params = { :action => "page", :controller => "1"}
    end
    
  end
    
  

  it "should link to the right page" do
    params = HashWithIndifferentAccess.new(:controller => "projects", :action => "index")
    view = TestView.new
    view.controller = ProjectsController
    view.header_and_title
  end
  
  
  it "should correctly colour the text" do
    path = "#{RAILS_ROOT}/spec/fixtures/colour/sample_stdout.html"
    File.open(path, "w+") do |f|
      f.write "<link rel='stylesheet' href='style.css'>"
      f.write "This test in #{__FILE__}:#{__LINE__} is passing if the text below is coloured and looks good :P"
      f.write "<pre>"
      f.write color_format(File.read("#{RAILS_ROOT}/spec/fixtures/colour/sample_stdout"))
      f.write "</pre>"
    end
    `open #{path}`
  end
end