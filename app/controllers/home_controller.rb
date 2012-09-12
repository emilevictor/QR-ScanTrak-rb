class HomeController < ApplicationController
  def index
  	if user_signed_in?
		@user = current_user
		if not @user.nil?

			@team = Team.find(@user.team_id)

		else
			flash[:alert] = "There didn't seem to be a user signed in"

		end
  	end
  end
end