Rails.application.routes.draw do
  get "home", to: "home#index", as: "home"

  get "kotobakensaku", to: "kotobakensaku#kensaku", as: "kotoba"
  get "kotobakensaku/kensaku", to: "kotobakensaku#kensaku", as: "kotoba_kensaku"
  get "kotobakensaku/sentaku_sakujyo", to: "kotobakensaku#sentaku_sakujyo", as: "kotoba_sentaku_sakujyo"
  get "kotobakensaku/csv_shutsuryoku", to: "kotobakensaku#csv_shutsuryoku", as: "kotoba_csv_shutsuryoku"  
  get "kotobakensaku/excel_shutsuryoku", to: "kotobakensaku#excel_shutsuryoku", as: "kotoba_excel_shutsuryoku"  

  get "kotobahenshu/henshu", to: "kotobahenshu#henshu", as: "kotoba_henshu"  
  get "kotobahenshu/hozon", to: "kotobahenshu#hozon", as: "kotoba_hozon"
  post "kotobahenshu/csv_upload", to: "kotobahenshu#csv_upload", as: "kotoba_csv_upload"  

  get "kaisuyomi", to: "kaisuyomi#yomi", as: "kaisuyomi"
  get "kaisuyomi/yomi", to: "kaisuyomi#yomi", as: "kaisuyomi_yomi"

  resources :kotobahenshu do
    collection { post :import }
  end

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
