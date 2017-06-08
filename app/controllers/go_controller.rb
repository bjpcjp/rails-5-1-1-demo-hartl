class GoController < ApplicationController

  def home
  	# listing 13.47
  	if logged_in?
  		# listing 13.40
    	@micropost = current_user.microposts.build
    	@feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end
  
  def contact
  end
  
end
