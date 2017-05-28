class SessionsController < ApplicationController

  def new
  end

  def create # listing 8.6

  	# listing 8.7
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    	# listing 8.15
    	log_in user
    	redirect_to user 
    else
    	# listing 8.8
      	flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
    	render 'new'
    end
 end

  def destroy # listing 8.30
  	log_out
  	redirect_to root_url
  end

end
