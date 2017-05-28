class UsersController < ApplicationController

  def new
  	@user = User.new                  # listing 7.14
  end

                                      # listing 7.5
  def show
  	@user = User.find(params[:id])
  	#debugger                         # listing 7.6
  end


                                      # listing 7.18
  def create
  	#@user = User.new(params[:user])
  	@user = User.new(user_params)     # listing 7.19
  	if @user.save
      log_in @user                    # listing 8.25
  		flash[:success] = "Welcome!"    # listing 7.29
  		redirect_to @user               # listing 7.28
  	else
  		render 'new'
  	end
  end

  private

  def user_params                     # listing 7.19
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
