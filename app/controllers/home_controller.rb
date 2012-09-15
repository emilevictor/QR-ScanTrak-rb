class HomeController < ApplicationController
  def index
  	if user_signed_in?
		@user = current_user
		if not @user.nil? and not @user.team_id.nil?

			@team = Team.find(@user.team_id)
		
		elsif @user.team_id.nil? and not @user.nil?

			flash[:notice] = "You are not yet in a team. This needs to be rectified immediately!"

		else
			flash[:alert] = "There didn't seem to be a user signed in"

		end
  	end
  end

  def createTeam

  	@user = current_user

  	if not @user.nil? and @user.team_id.nil?

  	@team = Team.new

  	respond_to do |format|
  		format.html
  		format.json
  	end

  else
  	flash[:alert] = "You are trying to create a team, but you are already in one!"
  	redirect_to :controller => "home", :action => "index"
  end

  end



end