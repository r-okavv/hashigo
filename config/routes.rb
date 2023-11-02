Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  root 'static_pages#top'
  # root 'restaurants#index'
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => "user_sessions#create"
  delete 'logout' => 'user_sessions#destroy', :as => :logout

  get 'user_sessions/new'
  get 'user_sessions/create'
  get 'user_sessions/destroy'

  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

  resources :users, only: %i[new create]
  resources :password_resets, only: %i[new create edit update]
  resources :restaurants, only: %i[index show] do
    collection do
      get :search
      get :bookmarks
    end
    member do
      post 'update_tag'
    end
  end
  post 'select_restaurants', to: 'restaurants#random_select', as: 'select_restaurants'
  post 'get_location', to: 'locations#get_location'
  resources :bookmarks, only: %i[create destroy]
  get "/pages/*id" => 'pages#show', as: :page, format: false
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
