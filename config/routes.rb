Rails.application.routes.draw do
  resources :messages
  resources :teams
  resources :users
  root to: 'visitors#index', constraints: { subdomain: '' }

  get '/', to: 'visitors#index', constraints: { subdomain: 'www' }
  get '/', to: 'users#index', constraints: { subdomain: /.+/ }

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'




end
