class HomeController < ApplicationController
  def index
  	if user_signed_in?
		@user = current_user
		@team = Team.find(@user.team_id)
  	end
  end
end