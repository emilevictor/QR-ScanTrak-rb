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

	it "allows you to register" do
		visit(new_user_registration_path)
		within('#content') do
			fill_in 'user_email', :with => 'asdf@asdf.com'
			fill_in 'First name', :with => 'ACME'
			fill_in 'Last name', :with => 'LastName'
			fill_in 'Password', :with => 'password'
			fill_in 'Password confirmation', :with => 'password'
			click_button "Sign up"
		end


		page.should have_content("In order to play a QR ScanTrak game")

	end

	# it "allows you to access the edit registration page" do
	# 	@user = FactoryGirl.create(:user2)
	# 	@game = FactoryGirl.create(:UQGame)

	# 	#Log our user in
	# 	visit new_user_session_path
	#  	fill_in 'user_email', :with => @user.email
	#  	fill_in 'user_password', :with => 'password'
	#  	click_button 'Sign in'

	#  	#Check that the page is asking us for the new game
	#  	page.should have_content("Enter a game ID")
	#  	#Join the game
	#  	fill_in 'gameID', :with => @game.id
	#  	click_button 'Join Game'
	 	
	# 	visit(edit_user_registration_path)
	# 	response.should be_success

	# end

	it "will allow you to create a full team" do
		#debugger
		@user = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user)
		@user3 = FactoryGirl.create(:user)
		@user4 = FactoryGirl.create(:user)
		@user5 = FactoryGirl.create(:user)
	 	@team = FactoryGirl.create(:team)
	 	@game = FactoryGirl.create(:UQGame)
	 	@user.created_teams = [@team]
	 	@user.teams = [@team]
	 	@game.teams = [@team]
	 	@user.games = [@game]

	 	#Log our user in
		visit new_user_session_path
	 	fill_in 'user_email', :with => @user.email
	 	fill_in 'user_password', :with => 'password'
	 	click_button 'Sign in'

	 	#page.should have_content(@team.name)
	 	visit(teams_AddPlayersToMyTeam_path)

	 	@number = Settings.maxTeamMembers-@team.users.count
	 	page.should have_content("You have " + (Settings.maxTeamMembers-@team.users.count).to_s + " slots left")

	 	fill_in 'email', :with => @user2.email
	 	click_button 'Add User'

	 	page.should have_content(@user2.email)
	 	page.should have_content(@user.email)

	 	visit(teams_AddPlayersToMyTeam_path)

	 	@number = @number - 1
	 	page.should have_content("You have " + (@number).to_s + " slots left")

	 	fill_in 'email', :with => @user3.email
	 	click_button 'Add User'

	 	page.should have_content(@user3.email)

	 	visit(teams_AddPlayersToMyTeam_path)

	 	fill_in 'email', :with => @user4.email
	 	click_button 'Add User'

	 	page.should have_content(@user4.email)

	 	visit(teams_AddPlayersToMyTeam_path)

	 	fill_in 'email', :with => @user5.email
	 	click_button 'Add User'

	 	page.should have_content(@user5.email)


	 	#Trying to add a player who already exists
	 	visit(teams_AddPlayersToMyTeam_path)

	 	page.should have_content("Your team is full")



	 	#Now we start removing players

	 	visit(teams_removeTeamMembers_path)

	 	check("USERID_" + @user2.id.to_s)

	 	click_button("Remove")

	 	page.should have_content("Successfully removed members from team")

	 	#Go back to the team score page

	 	visit(teams_checkScore_path)

	 	page.should_not have_content(@user2.email)



	end


end
