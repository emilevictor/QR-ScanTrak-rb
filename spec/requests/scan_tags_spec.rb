require 'spec_helper'
require 'factory_girl'
require 'ruby-debug'

include Warden::Test::Helpers

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

	 	login_as @user, scope: :user

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

	it "correctly tracks placements" do
		@user = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user)
	 	@team = FactoryGirl.create(:team)
	 	@team2 = FactoryGirl.create(:team)
	 	@game = FactoryGirl.create(:UQGame)
	 	@user.teams = [@team]
	 	@user2.teams = [@team2]
	 	@game.teams = [@team, @team2]
		@tag = FactoryGirl.create(:tag)
		@tag2 = FactoryGirl.create(:tag2)
	 	@game.tags = [@tag, @tag2]
	 	@user.games = [@game]
	 	@user2.games = [@game]

	 	login_as @user, scope: :user

	 	#debugger
	 	visit('/tags/'+@tag.uniqueUrl+'/tagFound/')

	 	page.should have_content("You are the first team")
	 	page.should_not have_content("You are not an admin")

	 	click_button 'Claim'

	 	visit('/tags/'+@tag2.uniqueUrl+'/tagFound/')

	 	page.should have_content("You are the first team")
	 	page.should_not have_content("You are not an admin")

	 	click_button 'Claim'

	 	#Log user 1 out, log user 2 in, claim points

	 	logout(@user)

	 	login_as @user2, scope: :user

	 	#debugger
	 	visit('/tags/'+@tag.uniqueUrl+'/tagFound/')

	 	page.should have_content("You are the 2nd team")
	 	page.should_not have_content("You are the first team")

	 	click_button 'Claim'

	 	visit('/tags/'+@tag2.uniqueUrl+'/tagFound/')

	 	page.should have_content("You are the 2nd team")
	 	page.should_not have_content("You are the first team")

	 	click_button 'Claim'

	 	page.should have_content("Tied with #{@team.name}")




	end

	it "will ask you to join the right game if you scan a tag of a game that you don't belong to" do
		@user = FactoryGirl.create(:user)
	 	@team = FactoryGirl.create(:team)
	 	@game = FactoryGirl.create(:UQGame)
	 	@otherGame = FactoryGirl.create(:otherGame)
	 	@user.teams = [@team]
	 	@game.teams = [@team]
		@tag = FactoryGirl.create(:tag)
		@tag2 = FactoryGirl.create(:tag2)
	 	@otherGame.tags = [@tag, @tag2]
	 	@user.games = [@game]

	 	login_as @user, scope: :user

	 	#debugger
	 	visit('/tags/'+@tag.uniqueUrl+'/tagFound/')

	 	page.should have_content("Join an Existing Game")


	end

	it "will ask you to log in if you haven't, when you scan a tag" do
		@tag = FactoryGirl.create(:tag)

	 	visit('/tags/'+@tag.uniqueUrl+'/tagFound/')

	 	page.should have_content('Sign in')
	 	page.should have_content('first time playing')

	end




end