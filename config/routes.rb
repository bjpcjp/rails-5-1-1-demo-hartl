Rails.application.routes.draw do
  
  get 'go/home'
  get 'go/help'
  get 'go/about'

  # listing 3.5
  #root 'application#hello'

  # listing 3.41
  root 'go#home'
  
end
