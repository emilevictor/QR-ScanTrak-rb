class HomeController < ApplicationController
  def index
  	if user_signed_in?
  		@user = current_user
      @team = @user.currentGame().teams.where(:user_id => @user.id).first
  		@game = current_user.currentGame()
  	end
  end

  def createTeam

  	@user = current_user

	if not @user.nil? and @user.currentGame().teams.where(:user_id => @user.id).empty?

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