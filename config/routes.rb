ActionController::Routing::Routes.draw do |map|

  map.resources :projects, :requirements => {:id => /[a-zA-Z0-9\.-]+/ } do |project|
    project.resources :branches, :requirements => {:id => /[a-zA-Z0-9\.-]+/ } do |branch|
      branch.resources :builds, :member => { :rebuild => :put }, :requirements => { :branch_id => /[a-zA-Z0-9\.-]+/ } 
    end
    
    project.resources :builds, :member => { :rebuild => :put }, :requirements => { :project_id => /[a-zA-Z0-9\.-]+/ } 
  end
  
  map.connect "github", :controller => "projects", :action => "github", :conditions => { :method => :post }
  map.connect "codebase", :controller => "projects", :action => "codebase", :conditions => { :method => :post }
  map.connect "xml", :controller => "projects", :action => "index", :format => "xml"
  map.connect "setup/github", :controller => "setup", :action => "github"
  map.connect "setup/codebase", :controller => "setup", :action => "codebase"
  map.root :projects
end
