Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/inc", to: "cart#increment_quantity"
  patch "/cart/:item_id/dec", to: "cart#decrement_quantity"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'
  get '/profile/edit/password', to: 'users#edit'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get "/profile/orders/:id", to: "user/orders#show"
  get '/profile/orders', to: 'user/orders#index'
  delete '/profile/orders/:id', to: 'user/orders#destroy'

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/dashboard', to: 'dashboard#index'
    get '/items', to: 'items#index'
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/users/:user_id', to: 'users#show'
    get '/dashboard', to: 'dashboard#index'
    post '/orders/:order_id/update', to: 'orders#update'
  end
end
