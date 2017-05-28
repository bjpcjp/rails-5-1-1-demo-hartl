class SessionsController < ApplicationController

  def new
  end

  def create 										# listing 8.6
  													# listing 8.7
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    	log_in user 								# listing 8.15
    	#remember user								# listing 9.7
    	params[:session][:remember_me] == '1' ?		# listing 9.23
    	remember(user) : forget(user)
    	redirect_to user 
    else
    												# listing 8.8
      	flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
    	render 'new'
    end
 end

  def destroy 										# listing 8.30
  	log_out if logged_in?							# listing 9.16
  	redirect_to root_url
  end

end
