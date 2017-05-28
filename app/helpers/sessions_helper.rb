module SessionsHelper

  def log_in(user) # listing 8.14
    session[:user_id] = user.id
  end

  def current_user # listing 8.16
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in? # listing 8.18
    !current_user.nil?
  end

  def log_out # listing 8.29
  	session.delete(:user_id)
  	@current_user = nil
  end
  
end
