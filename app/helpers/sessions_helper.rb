module SessionsHelper

  def log_in(user) # listing 8.14
    session[:user_id] = user.id
  end

  def remember(user) # listing 9.8
  	user.remember
  	cookies.permanent.signed[:user_id] = user.id
  	cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user # listing 8.16
  	# listing 9.9
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      #raise # listing 9.29; removed in 9.33.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in? # listing 8.18
    !current_user.nil?
  end

  def forget(user) # listing 9.12
  	user.forget
  	cookies.delete(:user_id)
  	cookies.delete(:remember_token)
  end

  def log_out # listing 8.29
  	forget(current_user) # listing 9.12
  	session.delete(:user_id)
  	@current_user = nil
  end
  
end
