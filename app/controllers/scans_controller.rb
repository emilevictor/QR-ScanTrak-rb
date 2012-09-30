class ScansController < ApplicationController

	def index
		if current_user.try(:admin?)

			@scans = current_user.currentGame().scans.all
		  
		  respond_to do |format|
		    format.html # index.html.erb
		    format.json { render json: @tags }
		  end

		else
		  flash[:notice] = 'You need admin privileges to go there.'
		  redirect_to :controller => "home", :action => "index"
		end

	end




	def last30Scans
		@scans = Scan.find(:all, :order => "updated_at desc", :limit => 30)
		@scans.each do |scan|
			scan["latitude"] = scan.tag.latitude
			scan["longitude"] = scan.tag.longitude
		end
		respond_to do |format|
			format.json {render json: @scans}
		end


	end

	#You can access this by going to /admin/scans/lastNScansForThisGame/(numberOfScans).json
	def lastNScansForThisGame
		
		@scans = current_user.currentGame().scans.find(:all, :order => "updated_at desc", :limit => params[:limit].to_i)
		@scans.each do |scan|
			if scan.thisIsAPointModification
				scan["team_name"] = Team.find(scan.team_id).name
				scan["points"] = scan.modPoints
				scan["tag_name"] = "MODERATOR"
			else
				scan["tag_name"] = Tag.find(scan.tag_id).name
				scan["team_name"] = Team.find(scan.team_id).name
				scan["points"] = Tag.find(scan.tag_id).points

			end

		end
		respond_to do |format|
			format.json{render json: @scans}
		end
	end


	  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    if current_user.try(:admin?)
      @scan = Scan.find(params[:id])
      @scan.destroy

      respond_to do |format|
        format.html { redirect_to scans_url }
        format.json { head :no_content }
      end
    else
      flash[:notice] = 'You need admin privileges to go there.'
      redirect_to :controller => "home", :action => "index"
    end
  end

end
