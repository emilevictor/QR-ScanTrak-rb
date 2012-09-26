class HomeController < ApplicationController
  def index
  	if user_signed_in?
  		@user = current_user
      if not @user.currentGame().nil?
        @team = current_user.teams.where(:game_id => current_user.currentGame().id).first
        @game = current_user.currentGame()
      else

      end
      
  	end
  end

  def createTeam

  	@user = current_user

	if not @user.nil? and current_user.teams.where(:game_id => current_user.currentGame().id).empty?

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