Rails.application.routes.draw do
  
  get 'sessions/new'
  get 'users/new'

  #get 'go/home'
  #get 'go/help'
  #get 'go/about'
  #get 'go/contact'

  # listing 5.27
  get '/help',		to: 'go#help'
  get '/about',		to: 'go#about'
  get '/contact',	to: 'go#contact'
  
  # listing 3.5
  #root 'application#hello'

  # listing 3.41
  root 'go#home'
  
  # listing 5.43
  get '/signup',	to: 'users#new'
  
  # listing 7.3
  resources :users
  
  # listing 8.2
  get '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # listing 11.1
  resources :account_activations, only: [:edit]

  # listing 12.1
  resources :password_resets, only: [:new, :create, :edit, :update]
end
