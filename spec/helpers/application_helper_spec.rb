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
    pending
    params = HashWithIndifferentAccess.new(:controller => "projects", :action => "index")
    view = TestView.new
    view.controller = ProjectsController
    view.header_and_title
  end
  
  
  it "should correctly colour the text" do
    actual = color_format %(
      Scenario: Create new document template\e[90m                                 # features/document_templates_create_document_template.feature:13\e[0m
        \e[32mGiven I am logged in as a user\e[90m                                       # features/step_definitions/app_steps.rb:1\e[0m\e[0m
        \e[32mWhen I go to \e[32m\e[1mthe homepage\e[0m\e[0m\e[32m\e[90m                                            # features/step_definitions/webrat_steps.rb:10\e[0m\e[0m
        \e[32mAnd I follow "\e[32m\e[1mDocument Templates\e[0m\e[0m\e[32m"\e[90m                                    # features/step_definitions/webrat_steps.rb:18\e[0m\e[0m
        \e[32mAnd I follow "\e[32m\e[1mNew Document Template\e[0m\e[0m\e[32m"\e[90m                                 # features/step_definitions/webrat_steps.rb:18\e[0m\e[0m
    )
    
    expected = %(
      Scenario: Create new document template<span class="color90">                                 # features/document_templates_create_document_template.feature:13</span>
        <span class="color32">Given I am logged in as a user<span class="color90">                                       # features/step_definitions/app_steps.rb:1</span></span>
        <span class="color32">When I go to <span class="color1">the homepage</span></span><span class="color32"><span class="color90">                                            # features/step_definitions/webrat_steps.rb:10</span></span>
        <span class="color32">And I follow "<span class="color1">Document Templates</span></span><span class="color32">"<span class="color90">                                    # features/step_definitions/webrat_steps.rb:18</span></span>
        <span class="color32">And I follow "<span class="color1">New Document Template</span></span><span class="color32">"<span class="color90">                                 # features/step_definitions/webrat_steps.rb:18</span></span>
    )
    
    expected.should == actual
  end
end