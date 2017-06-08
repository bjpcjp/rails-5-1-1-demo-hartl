class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  include SessionsHelper # listing 8.13

  def hello # listing 3.4
  	render html: 'hello world'
  end

  private

  # moved from users_controller - listing 13.32
  # moved here because it's needed by both 'Users' & 'Microposts' controllers
  #
    
  def logged_in_user                  # listing 10.15
    unless logged_in?
      store_location                  # listing 10.31 - for friendly forwarding
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end
