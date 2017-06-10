class RelationshipsController < ApplicationController

  # listing 14.32
  before_action :logged_in_user

  # listing 14.36:
  # 1) 'user' chgd to '@user' - now need instance variable
  #
  def create # listing 14.33
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    #redirect_to user

    # listing 14.36 -- respond to Ajax requests
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end

  end

  def destroy # listing 14.33
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    #redirect_to user
    
    # listing 14.36 -- respond to Ajax requests
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end

  end

end
