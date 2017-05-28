class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  include SessionsHelper # listing 8.13

  def hello # listing 3.4
  	render html: 'hello world'
  end

end
