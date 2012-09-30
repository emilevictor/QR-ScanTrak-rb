class ModeratorsController < ApplicationController
	#addOrRemovePoints.html.erb
	def addOrRemovePointsFromTeam
		if current_user.moderates_this_game(current_user.currentGame()) or current_user.try(:admin?)
			respond_to do |format|
				format.html
			end



		else
			flash[:notice] = "You need to be a moderator to be able to do that."
			redirect_to home_index_path and return

		end


	end

	def processPoints
				

		if params[:teamID].empty? or params[:points].empty? or params[:comments].empty?
			flash[:alert] = "You missed something! You need to enter all of the information requested on this page."
			redirect_to addOrRemovePointsFromTeam_path and return
		else
			@team = Team.find_by_id(params[:teamID].to_i)
			if not @team.nil? and @team.game.id == current_user.currentGame().id
				@scan = Scan.new
				@scan.game = current_user.currentGame()
				@scan.thisIsAPointModification = true
				@scan.modPoints = params[:points].to_i
				@scan.team_id = params[:teamID].to_i
				@scan.comment = params[:comments]
				@scan.save
				flash[:notice] = "Points successfully modified"
				redirect_to addOrRemovePointsFromTeam_path and return
			else
				flash[:alert] = "That team doesn't exist!"
				redirect_to addOrRemovePointsFromTeam_path and return
			end
		end

	end

end
