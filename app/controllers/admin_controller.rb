class AdminController < ApplicationController

	def index
		    if not current_user.try(:admin?)

		    	flash[:alert] = "You need to be an admin to use the administrator panel."
		    	redirect_to :controller => "home", :action => "index"
		    end
	end



end
