Rails.application.routes.draw do
  # root 'static_pages#top'
  root 'restaurants#index'
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => "user_sessions#create"
  delete 'logout' => 'user_sessions#destroy', :as => :logout

  get 'user_sessions/new'
  get 'user_sessions/create'
  get 'user_sessions/destroy'

  resources :users, only: %i[new create]
  resources :restaurants, only: %i[index show] do
  end
  post 'get_location', to: 'locations#get_location'
  resources :bookmarks, only: %i[create destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
