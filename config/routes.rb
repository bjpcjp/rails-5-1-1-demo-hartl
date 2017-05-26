Rails.application.routes.draw do
  
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
  
end
