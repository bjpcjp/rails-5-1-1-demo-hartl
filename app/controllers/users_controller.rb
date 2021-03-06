class UsersController < ApplicationController

  #before_action :logged_in_user, only: [:edit, :update] # listing 10.15
  #before_action :logged_in_user, only: [:index, :edit, :update] # listing 10.35
  before_action :logged_in_user, only: [:index, :edit,
                                        :update, :destroy,
                                        :following, :followers] # listing 10.58

  before_action :correct_user,   only: [:edit, :update] # listing 10.25
  before_action :admin_user,     only: :destroy


  def index                           # listing 10.35
    #@users = User.all                 # listing 10.36
    @users = User.paginate(page: params[:page])   # listing 10.46
  end

  def new                             # listing 7.14
  	@user = User.new                  
  end

# listing 13.23:
# 'will_paginate' assumes existence of '@users' instance variable
# when used in context of 'Users' controller.
# in this case we want to paginate microposts -
# so explicitly pass @microposts variable instead.
#
  def show                            # listing 7.5
  	@user = User.find(params[:id])
  	#debugger                         # listing 7.6
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # listing 7.18, 7.19, 7.28, 7.29, 8.25, 11.23, 11.36
  def create                          
  	@user = User.new(user_params)     
  	if @user.save
      #UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "Done! Please check your email for an activation link."
      redirect_to root_url
      
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

  # listing 14.25 
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private

  def user_params                     # listing 7.19
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # listing 13.33
  # moved to application_controller (see listing 13.32)

  #def logged_in_user                  # listing 10.15
  #  unless logged_in?
  #    store_location                  # listing 10.31 - for friendly forwarding
  #    flash[:danger] = "Please log in."
  #    redirect_to login_url
  #  end
  #end

  # before filters
  
  def correct_user                    # listing 10.25
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)  # listing 10.28
  end

  def admin_user                      # listing 10.59
    redirect_to(root_url) unless current_user.admin?
  end


end
