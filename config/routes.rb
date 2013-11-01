LifeAdvisor::Application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "user_home/index"
	get 'home' => "user_home#index"
  get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
	root :to => 'action_items#index'

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


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
