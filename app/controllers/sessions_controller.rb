class SessionsController < ApplicationController

  def new
  end

  def create # listing 8.6
  	# listing 8.7
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated? # listing 11.32
    	   log_in user # listing 8.15
    	   #remember user # listing 9.7
         # listing 9.23
    	   params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    	   #redirect_to user 
    	   redirect_back_or user # listing 10.32
      else
    		# listing 8.8
      	#flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
    	  message  = "account not activated. "
        message += "check your email for the activtion link."
        flash[:warning] = message
        #render 'new'
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'invalid email/password combination'
      render 'new'
    end
 end

  def destroy # listing 8.30
  	log_out if logged_in?	# listing 9.16
  	redirect_to root_url
  end

end
