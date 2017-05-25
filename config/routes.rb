Rails.application.routes.draw do
  
  get 'go/home'

  get 'go/help'

  # listing 3.5
  root 'application#hello'

end
