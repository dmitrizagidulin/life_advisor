LifeAdvisor::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  controller :action_items do
    get 'action_items/completed' => :completed
    get 'action_items/all' => :all
    post 'action_items/toggle_done/:id' => :toggle_done
    post 'action_items/:id/category/:category' => :category_update
    post 'action_items/category_update_all' => :category_update_all
  end
  resources :action_items
  resources :questions
  
  controller :projects do
    get 'projects/completed'
    get 'projects/canceled'
    post 'projects/:id/status/:status' => :status_update
  end
  resources :projects
  resources :history
  resources :web_links
  resources :thoughts
  
  controller :focus do
    get 'focus/:area' => :focus_area
  end
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'action_items#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
