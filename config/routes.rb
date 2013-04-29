Yxran::Application.routes.draw do
  


  devise_for :users
  
  resources :users
  resources :members
  resources :sales
  match 'sale/retail', :to => 'sales#retail'
  match 'sale/cost', :to => 'sales#cost'

  
  
  resources :products
  resources :stocks
  resources :carts
  match '/switch_discount',:to => 'carts#switch_discount'
  resources :handovers
  resources :expenses
  resources :transfers
  
  
  
  namespace :maintain do
    match '/dashboard',:to => 'dashboard#index'
    resources :categories
    resources :products
    resources :stores
    resources :users
    resources :discounts
    resources :sales
    resources :members
    resources :orders do
      resources :order_details
    end
    resources :transfers do
      member do
        get :transfer
      end
      resources :transfer_details
    end
    #match 'transfer/transfer', :to => 'transfer#transfer'
    
    resources :stocks do
      resources :histories
    end
    resources :handovers
    resources :expenses
    resources :balances
  end
  
  namespace :admin do
    match '/dashboard',:to => 'dashboard#index'
    resources :lookups
    resources :switches
    resources :events
    
  end
  
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
