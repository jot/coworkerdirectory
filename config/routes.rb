Rails.application.routes.draw do
  
  
  resources :presences
  resources :answers
  resources :questions
  resources :channels
  # Added by Koudoku.
  mount Koudoku::Engine, at: 'koudoku'
  scope module: 'koudoku' do
    get 'pricing' => 'subscriptions#index', as: 'pricing'
  end


  resources :messages
  resources :teams
  resources :users
  root to: 'marketing#index', constraints: { subdomain: '' }
  get '/', to: 'marketing#index', constraints: { subdomain: 'www' }
  get '/', to: 'users#index', constraints: { subdomain: /.+/ }

  get '/plans', to: 'marketing#plans'
  get '/privacy', to: 'marketing#privacy'
  get '/terms', to: 'marketing#terms'
  get '/working', to: 'marketing#working'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'




end
