ActionController::Routing::Routes.draw do |map|
  map.resources :projects do |project|
    project.resources :builds
  end
  
  map.connect "receive", :controller => "projects", :action => "receive", :conditions => { :method => :post }
  map.root :projects
end
