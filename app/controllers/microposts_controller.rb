class MicropostsController < ApplicationController

  # listing 13.34
  before_action :logged_in_user, only: [:create, :destroy]
  # listing 13.52
  before_action :correct_user, only: :destroy


  # listing 13.36
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # listing 13.50 -- add empty @feed_items to 'create' action.
      @feed_items = []
      render 'go/home'
    end
  end

  def destroy # listing 13.52
    #
    # microposts appear on both home & user profile pages,
    # so 'request.referrer' allows redirect back to issuing action.
    #
    @micropost.destroy
    flash[:success] = "Micropost deleted."
    redirect_to request.referrer || root_url
  end

  private

  	# listing 13.36 - used in create actions
  	# only allow micropost.content to be modified.
    #
    # listing 13.61 - add :picture to attributes for image upload
    #
    def micropost_params
      #params.require(:micropost).permit(:content)
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user # listing 13.52
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
