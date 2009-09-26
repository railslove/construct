ActionController::Routing::Routes.draw do |map|
  
  map.resources :projects do |project|
    project.resources :branches do |branch|
      branch.resources :builds, :member => { :rebuild => :put }
    end
    
    project.resources :builds, :member => { :rebuild => :put }
  end
  
  map.connect "github", :controller => "projects", :action => "github", :conditions => { :method => :post }
  map.connect "codebase", :controller => "projects", :action => "codebase", :conditions => { :method => :post }
  map.root :projects
end
