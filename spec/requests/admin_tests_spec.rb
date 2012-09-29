require 'spec_helper'
include Warden::Test::Helpers

describe "AdminTests" do
  
	it "allows you to mass create tags" do
		@user = FactoryGirl.create(:adminUser)
		@game = FactoryGirl.create(:UQGame)
		@user.games = [@game]
	 	@team = FactoryGirl.create(:team)
	 	@user.teams = [@team]

	 	@numberOfTags = Tag.all.count

		login_as @user, scope: :user

	 	visit('/admin/tags/massGenerateTags')

	 	page.should have_content("Mass generate")

	 	fill_in 'numberOfTags', :with => 1
	 	fill_in 'addressTag', :with => "St Lucia, Brisbane, Queensland, Australia"
	 	check("useNegativePoints")
	 	click_button("Generate")

	 	#page.should have_content("wtf")
	 	#debugger


	 	@newNumberOfTags = Tag.all.count

	 	@newNumberOfTags.should_not eql @numberOfTags

	end

	it "allows you to create a game" do
		@user = FactoryGirl.create(:adminUser)

		
		visit ('/admin/games')
		page.should have_content("You need to sign in")

	 	fill_in 'user_email', :with => @user.email
	 	fill_in 'user_password', :with => 'password'
	 	click_button 'Sign in'

	 	page.should have_content("Listing games")

	 	click_link 'New Game'

	 	page.should have_content("New game")

	 	fill_in 'game_name', :with => "game"
	 	fill_in 'game_organisation', :with => "gameorganisation"
	 	fill_in 'game_shortID', :with => "ASDF"
	 	fill_in 'game_maxNumberOfPlayers', :with => 33
	 	check("game_showGameInfoOnPrintedTags")
	 	check("game_showLogoOnPrintedTags")
	 	check("game_showPasswordOnPrintedTags")
	 	check("game_addQRScanTrakLogoOnPrintedTags")
	 	click_button 'Create'

	 	page.should have_content("ASDF")

 	
	end

end
