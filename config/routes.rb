Rails.application.routes.draw do
  root 'static_pages#top'
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => "user_sessions#create"
  delete 'logout' => 'user_sessions#destroy', :as => :logout

  get 'user_sessions/new'
  get 'user_sessions/create'
  get 'user_sessions/destroy'

  resources :users, only: %i[new create]
  # get 'search', to: 'searches#search', as: 'search'
  # post 'search', to: 'searches#search'
  # get 'result', to: 'searches#result', as: 'result'
  resources :restaurants, only: [:index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
