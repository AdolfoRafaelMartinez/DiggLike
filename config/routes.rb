ActionController::Routing::Routes.draw do |map|
  map.rateup '/rateup/:id', :controller => 'posts', :action => 'rateup' 
  map.ratedn '/ratedn/:id', :controller => 'posts', :action => 'ratedn' 
  map.thumbs '/thumbs', :controller => 'posts', :action => 'thumbs'
  map.thumbs '/parked', :controller => 'posts', :action => 'parked'
  map.resources :posts, :has_many => :comments 
  map.root :controller => "home" 
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

