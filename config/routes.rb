ActionController::Routing::Routes.draw do |map|
  map.resources :rhelps

	map.root 							:controller => 'resumes', 	:action => 'home'
	map.connect '/new',					:controller => 'resumes', 	:action => 'new'
	map.connect '/home',				:controller => 'resumes', 	:action => 'home'
	map.connect '/edit/:title',			:controller => 'resumes', 	:action => 'edit'
	map.connect '/edit2/:title',		:controller => 'resumes', 	:action => 'edit2'
	map.connect '/dashboard/:title',	:controller => 'resumes', 	:action => 'dashboard'
	map.connect '/options/:title',		:controller => 'resumes', 	:action => 'options'
	map.connect '/view/:title',			:controller => 'resumes', 	:action => 'view'
	map.connect '/index',				:controller => 'resumes', 	:action => 'index'	

	map.connect '/dummy001/:title',		:controller => 'resumes', 	:action => 'dummy001'
	map.connect '/create/subpart',		:controller => 'subparts',	:action => 'create'
	map.connect '/destroy/subpart',		:controller => 'subparts',	:action => 'destroy'
	
	map.connect '/new/:title/part',		:controller => 'parts', 	:action => 'new'
	map.connect '/create/:title/part',	:controller => 'parts', 	:action => 'create'
	map.connect '/new2/:title/part',	:controller => 'parts', 	:action => 'new2'
	map.connect '/create2/part',		:controller => 'parts', 	:action => 'create2'

	map.connect '/new/subpart/:part_id',	:controller => 'subparts', 	:action => 'new'	

	map.connect '/trial',	:controller => 'users',		:action => 'trial'
	map.connect '/login',	:controller => 'users', 	:action => 'login'
	map.connect '/logout',	:controller => 'users', 	:action => 'logout'
	map.connect '/signup',	:controller => 'users', 	:action => 'signup'
	map.connect '/user/create',	:controller => 'users', 	:action => 'create'	
	map.connect '/user/check_availability',	:controller => 'users', 	:action => 'check_availability'	
	
	map.connect '/create',	:controller => 'resumes',	:action => 'create'
	map.connect '/create2',	:controller => 'resumes',	:action => 'create2'
	map.connect '/update2',	:controller => 'resumes',	:action => 'update2'
	map.connect '/set_default_resume',	:controller => 'users', 	:action => 'set_default_resume'

	map.connect '/update/:title',	:controller => 'resumes',	:action => 'update'
	map.connect '/destroy/:title',	:controller => 'resumes',	:action => 'destroy'
	map.connect '/makepdf/:title',	:controller => 'resumes',	 :action => 'makepdf'
	map.connect '/toggle_public_status',	:controller => 'resumes',	:action => 'toggle_public_status'
	map.connect '/preview/:title/:rtname',	:controller => 'rtemplates', :action => 'preview'
	map.connect '/set_rtemplates',			:controller => 'rtemplates', 	:action => 'set_rtemplates'

	#all the static pages
	map.connect '/faqs',		:controller => 'static_pages', 	:action => 'show', 	:page => 'faqs'
	map.connect '/about',		:controller => 'static_pages', 	:action => 'show', 	:page => 'about'
	map.connect '/contact',		:controller => 'static_pages', 	:action => 'show',	:page => 'contact'
	map.connect '/terms',		:controller => 'static_pages', 	:action => 'show',	:page => 'terms'
	map.connect '/privacy',		:controller => 'static_pages', 	:action => 'show',	:page => 'privacy'
	map.connect '/feedback',	:controller => 'static_pages', 	:action => 'show',	:page => 'feedback'

	# default for urls like /new/<title>/educations or create/<title>/contact	
	map.connect '/:action/:title/:controller'		

	# default url for user's public resume
	map.connect '/:username/:title',	:controller => 'resumes',	:action => 'view'
	
# 	old ones
#	map.connect '/show_p/:title',	:controller => 'resumes',	:action => 'show_p'
#	map.connect '/show/:title',		:controller => 'resumes',	:action => 'show'
#	map.connect '/edit/:title',		:controller => 'resumes',	:action => 'edit'
#	map.connect '/edit2/:title',	:controller => 'resumes',	:action => 'edit2'
#	map.connect '/edit3/:title',	:controller => 'resumes',	:action => 'edit3'
#	map.connect '/qedit/:title',	:controller => 'resumes',	:action => 'edit3'
#	map.connect '/qedit/:title/:part',	:controller => 'resumes',	:action => 'edit3'
#	map.connect '/:username/',			:controller => 'resumes',	:action => 'view'
#	map.connect '/home',	:controller => 'resumes', 	:action => 'home'
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
