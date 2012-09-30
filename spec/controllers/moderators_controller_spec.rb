require 'spec_helper'

describe ModeratorsController do

	it "allows moderators to add points to teams" do
		@user = FactoryGirl.create(:user)
		@game = FactoryGirl.create(:UQGame)
		@user.games = [@game]
	 	@team = FactoryGirl.create(:team)
	 	@user.teams = [@team]
	 	@game.moderators = [@user]

	 	#We want the user to be a moderator.


	end

end
