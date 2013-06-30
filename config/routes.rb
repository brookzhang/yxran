Yxran::Application.routes.draw do
  




  devise_for :users, :skip => [:registrations]
  resources :users do
    member do
      put :update_password
    end
  end
  
  resources :members
  match '/viewmember' => 'members#view'
 
  
  resources :sales do
    collection do
      get :retail
      get :cost
    end
    member do
      get :cancel
    end
  end

  
  
  resources :products do
    collection do
      get :list_by_category
    end
  end
  resources :stocks
  resources :carts
  resources :handovers
  resources :expenses do
    member do
      get :cancel
    end
  end
  
  resources :transfers do
    member do
      get :transfer
      get :receive
    end
    resources :transfer_details
  end
  
  resources :categories do
    collection do
      get :refresh_sub
      
    end
  end
  
  
  
  ### maintainer
  namespace :maintain do
    match '/dashboard',:to => 'dashboard#index'
    resources :reports do
      #match '/sale_details_report', :to => 'reports#sale_details_report'
      collection do
        get :sale_details_report
        get :sale_products_report
        get :sale_amount_by_store_report
        get :sale_amount_by_user_report
        get :sale_discount_report
        get :expense_details_report
        get :expense_amount_by_store_report
        get :expense_amount_by_user_report
        get :stock_details_report
        get :stock_movement_histories_report
      end
    end
    
    resources :categories
    resources :stores
    resources :users do
      resources :store_users
      member do
        get :lock
        get :unlock
      end
    end
    resources :discounts
    resources :sales
    resources :members
    resources :member_imports
    resources :orders
    resources :transfers
    #match 'transfer/transfer', :to => 'transfer#transfer'
    
    resources :stocks do
      resources :histories
    end
    resources :handovers
    resources :expenses
    resources :balances
  end
  
  
  
  ### admin
  namespace :admin do
    match '/dashboard',:to => 'dashboard#index'
    resources :lookups
    resources :switches
    resources :events
    resources :users
    
  end
  
  
  
  ### stocker
  namespace :stocker do
    match '/dashboard', :to => 'dashboard#index'
    resources :products
    resources :product_imports
    resources :orders do
      member do
        get :confirm
        get :cancel
      end
      resources :order_details
      resources :order_imports
      resources :products
    end
    
    
    
    resources :stocks do
      resources :histories
    end
    
    resources :users do
      member do
        put :update_password
      end
    end
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
