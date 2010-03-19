ActionController::Routing::Routes.draw do |map|
  allowed_route = /[a-zA-Z0-9\.\-_]+/
  map.resources :projects, :requirements => {:id => allowed_route } do |project|
    project.resources :branches, :member => { :build_latest => :any }, :requirements => {:id => allowed_route, :project_id => allowed_route } do |branch|
      branch.resources :builds, :member => { :rebuild => :put }, :requirements => { :branch_id => allowed_route, :project_id => allowed_route } 
    end
    project.resources :builds, :member => { :rebuild => :put }, :requirements => { :project_id => allowed_route } 
  end
  
  map.connect "github", :controller => "projects", :action => "github", :conditions => { :method => :post }
  map.connect "codebase", :controller => "projects", :action => "codebase", :conditions => { :method => :post }
  map.connect "xml", :controller => "projects", :action => "index", :format => "xml"
  map.connect "setup/github", :controller => "setup", :action => "github"
  map.connect "setup/codebase", :controller => "setup", :action => "codebase"
  map.root :projects
end
