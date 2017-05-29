class UsersController < ApplicationController

  #before_action :logged_in_user, only: [:edit, :update] # listing 10.15
  #before_action :logged_in_user, only: [:index, :edit, :update] # listing 10.35
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # listing 10.58

  before_action :correct_user,   only: [:edit, :update] # listing 10.25

  before_action :admin_user,     only: :destroy


  def index                           # listing 10.35
    #@users = User.all                 # listing 10.36
    @users = User.paginate(page: params[:page])   # listing 10.46
  end

  def new                             # listing 7.14
  	@user = User.new                  
  end

  def show                            # listing 7.5
  	@user = User.find(params[:id])
  	#debugger                         # listing 7.6
  end
  
  def create                          # listing 7.18
  	@user = User.new(user_params)     # listing 7.19
  	if @user.save
      log_in @user                    # listing 8.25
  		flash[:success] = "Welcome!"    # listing 7.29
  		redirect_to @user               # listing 7.28
  	else
  		render 'new'
  	end
  end

  def edit                            # listing 10.1
    @user = User.find(params[:id])
  end

  def update                          # listing 10.8
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # listing 10.12
      flash[:success] = "Profile updated"
      redirect_to @user

    else
      render 'edit'
    end
  end

  def destroy                         # listing 10.58
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params                     # listing 7.19
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user                  # listing 10.15
    unless logged_in?
      store_location                  # listing 10.31 - for friendly forwarding
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user                    # listing 10.25
    @user = User.find(params[:id])
    #redirect_to(root_url) unless @user == current_user
    redirect_to(root_url) unless current_user?(@user)  # listing 10.28
  end

  def admin_user                      # listing 10.59
    redirect_to(root_url) unless current_user.admin?
  end

end
