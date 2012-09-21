class AdminController < ApplicationController
	before_filter :authenticate_user!
	def index
		    if not current_user.try(:admin?)

		    	flash[:alert] = "You need to be an admin to use the administrator panel."
		    	redirect_to :controller => "home", :action => "index"
		    end
	end


	def mapOfTags
      respond_to do |format|
        format.html {render :layout => "printable"}
      end
	end

	def liveScanMap
      respond_to do |format|
        format.html {render :layout => "printable"}# index.html.erb
      end

	end

end
