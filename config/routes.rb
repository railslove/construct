ActionController::Routing::Routes.draw do |map|
  map.resources :projects do |project|
    project.resources :builds
  end
  
  map.connect "github", :controller => "projects", :action => "github", :conditions => { :method => :post }
  map.root :projects
end
