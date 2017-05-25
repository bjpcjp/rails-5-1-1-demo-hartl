class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # listing 3.4
  def hello
  	render html: 'hello world'
  end

end
