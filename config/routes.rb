Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'welcome#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :merchants
  resources :items
  resources :reviews, only: [:edit, :update, :destroy]
  resources :orders, only: [:new, :create]

  scope :merchants do
    get "/:merchant_id/items", to: "items#index"
    get "/:merchant_id/items/new", to: "items#new"
    post "/:merchant_id/items", to: "items#create"
  end

  scope :items do
    get "/:item_id/reviews/new", to: "reviews#new"
    post "/:item_id/reviews", to: "reviews#create"
  end

  scope :cart do
    post "/:item_id", to: "cart#add_item"
    get "/", to: "cart#show"
    delete "/", to: "cart#empty"
    delete "/:item_id", to: "cart#remove_item"
    patch "/:item_id/inc", to: "cart#increment_quantity"
    patch "/:item_id/dec", to: "cart#decrement_quantity"
  end

  scope :profile do
    get '/', to: 'users#show'
    get '/edit', to: 'users#edit'
    patch '/', to: 'users#update'
    get '/edit/password', to: 'users#edit'
  end

  scope :register do
    get '/', to: 'users#new'
    post '/', to: 'users#create'
  end

  scope :profile, module: :user do
    resources :orders, only: [:index, :show, :destroy]
  end

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/dashboard', to: 'dashboard#index'
    resources :items, except: :show

    scope :items do
      patch '/:id/edit', to: 'items#update_item'
    end
    
    scope :orders do
      get '/:id', to: 'orders#show'
      patch '/items/:id', to: 'item_orders#update'
    end
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/dashboard', to: 'dashboard#index'
    post '/orders/:order_id/update', to: 'orders#update'
    resources :users, only: [:index, :show]
    resources :merchants, only: [:index, :show, :update]
  end
end
