require 'spec_helper'
require 'factory_girl'
require 'ruby-debug'

describe "UserLogsIn" do
	 it "prompts you for a game if you are not in one" do
	 	@user = FactoryGirl.create(:user2)
	 	visit new_user_session_path
	 	fill_in 'user_email', :with => @user.email
	 	fill_in 'user_password', :with => 'password'
	 	click_button 'Sign in'
	 	page.should have_content("Signed in successfully")
	 	page.should have_content("In order to play a QR ScanTrak game")
	 end

	it "asks you to join a team if you have joined a game and not joined a team" do
		@user = FactoryGirl.create(:user2)
		@game = FactoryGirl.create(:UQGame)

		#Log our user in
		visit new_user_session_path
	 	fill_in 'user_email', :with => @user.email
	 	fill_in 'user_password', :with => 'password'
	 	click_button 'Sign in'

	 	#Check that the page is asking us for the new game
	 	page.should have_content("Enter a game ID")
	 	#Join the game
	 	fill_in 'gameID', :with => @game.id
	 	click_button 'Join Game'

	 	page.should have_content("Successfully joined the game " + @game.name)

	 	page.should have_content("Current Game: " + @game.name)

	 	page.should have_content("not in a team yet")

		#Now let's join a team.

		click_link 'Create a team here'

		page.should have_content("Create a team")

		@teamName = 'asdfasdfasdf'

		fill_in 'team_name', :with => @teamName
		fill_in 'team_description', :with => 'The best team full of pandas ever'
		fill_in 'team_password', :with => 'asdf'

		click_button 'Create Team'

		page.should have_content(@teamName)
		page.should have_content(@user.email)
	end


end
