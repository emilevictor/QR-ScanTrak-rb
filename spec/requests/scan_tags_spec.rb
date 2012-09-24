require 'spec_helper'
require 'factory_girl'
require 'ruby-debug'

describe "TagScanning" do

	it "will not crash and burn when you scan a tag and you are in a team" do

	 	@user = FactoryGirl.create(:user)
	 	@team = FactoryGirl.create(:team)
	 	@game = FactoryGirl.create(:UQGame)
	 	@user.teams = [@team]
	 	@game.teams = [@team]
		@tag = FactoryGirl.create(:tag)
		@tag2 = FactoryGirl.create(:tag2)
	 	@game.tags = [@tag, @tag2]
	 	@user.games = [@game]

	 	#Log our user in
		visit new_user_session_path
	 	fill_in 'user_email', :with => @user.email
	 	fill_in 'user_password', :with => 'password'
	 	click_button 'Sign in'

	 	#debugger
	 	visit('/tags/'+@tag.uniqueUrl+'/tagFound/')

	 	page.should have_content("You are the first team")
	 	page.should_not have_content("You are not an admin")

	 	click_button 'Claim'

	 	visit('/tags/'+@tag2.uniqueUrl+'/tagFound/')

	 	page.should have_content("You are the first team")
	 	page.should_not have_content("You are not an admin")

	 	click_button 'Claim'

	 	#We should be redirected to the team score page
	 	#it should include the tag name in the scans.
	 	page.should have_content(@team.name)
	 	page.should have_content(@tag.name)
	 	page.should have_content(@tag.points*2)

	end

	it "will ask you to log in if you haven't, when you scan a tag" do
		@tag = FactoryGirl.create(:tag)

	 	visit('/tags/'+@tag.uniqueUrl+'/tagFound/')

	 	page.should have_content('Sign in')
	 	page.should have_content('first time playing')

	end




end