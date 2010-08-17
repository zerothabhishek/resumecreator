ActionController::Routing::Routes.draw do |map|
  Clearance::Routes.draw(map)
  map.resources :users  
  map.root :controller => 'resumes', :action => 'index'
  map.resources :resumes,  :has_many => :parts
  map.resources :parts,  :has_many => :keyvaluepairs
  
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
