Rails.application.routes.draw do
  get 'orders/index'

  # config/routes.rb
resources :charges, only: [:index]
resources :orders
  root "home#index"
  devise_for :users

  get "/index", to: "home#index"
  get "/about", to: "home#about"
  post "checkout/create", to: "charges#create"
  get '/success', to: 'charges#success', as: 'success_charges'
  post 'checkout', to: "cart_items#checkout"
  post '/add_to_cart/:product_id', to: 'cart_items#add_item', as: 'add_to_cart'
  post '/subtract_from_cart/:product_id', to: 'cart_items#subtract_item', as: 'subtract_from_cart'
  resources :products
  resources :cart_items, only: [:index, :create, :destroy] 
  resources :payments
    
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
