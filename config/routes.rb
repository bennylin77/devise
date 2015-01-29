Rails.application.routes.draw do

  get 'nctu_cce/first'
  get 'nctu_cce/second'  
  get 'nctu_cce/third'
  get 'nctu_cce/editItem'  
  get 'nctu_cce/editGroup'  
  get 'nctu_cce/new'
  get 'nctu_cce/verified'
  get 'nctu_cce/indexManagement'
  get 'nctu_cce/showProgress'
  get 'nctu_cce/cancel'
  post 'nctu_cce/create'
  post 'nctu_cce/updateItem'   
  post 'nctu_cce/updateGroup'        
  post 'nctu_cce/second'  
    
  get 'main/index'
 
 
  get 'items/createCompletion' 
  get 'items/showManagement'
  get 'items/indexManagement'
  get 'items/progress'
 
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :items  
  resources :users
  root to: "items#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
