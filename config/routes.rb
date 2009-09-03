ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  map.connect '', :controller => 'home', :action => 'index'
  
  # appointments
  map.connect 'appointments/show/:date', :controller => 'appointments', :action => 'show', :date => ':date'
  
  # schedules
  map.connect 'schedules', :controller => 'schedules', :action => 'index'
  map.connect 'schedules/:action', :controller => 'schedules', :action => ':action'
  map.connect 'schedules/show/:id', :controller => 'schedules', :action => 'show', :id => ':id'
  map.connect 'schedules/edit/:id', :controller => 'schedules', :action => 'edit', :id => ':id'
  map.connect 'schedules/:year/:month', :controller => 'schedules', :action => 'month', :year => ':year', :month => ':month'
  map.connect 'schedules/:year/:month/:day', :controller => 'schedules', :action => 'week', :year => ':year', :month => ':month', :day => ':day'
  
  # sort table
  map.connect ':controller/:action/:sort_key/:sort_order'
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
  map.connect ':user/rss', :controller => 'home', :action => 'rss', :user => ':user'
end
