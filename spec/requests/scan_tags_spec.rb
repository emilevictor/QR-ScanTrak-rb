require 'spec_helper'
require 'factory_girl'

describe "TagScanning" do
	include Devise::TestHelpers

	before(:each) do
    	@user = Factory(:user) 
    	sign_in :user, @user 
	end

	it "will not crash and burn when you scan a tag and you are in a team" do
	 	#@user = FactoryGirl.create(:user)
		#@user = FactoryGirl.create(:user)
		#sign_in @user
	 	@team = FactoryGirl.create(:team)
	 	@game = FactoryGirl.create(:UQGame)
	 	@tag = FactoryGirl.create(:tag)


	 	@team.users << @user

	 	visit('/tags/'+@tag.uniqueUrl+'/tagFound/')

	 	page.should have_content("You are the first team")

	 	click_button 'Claim'

	 	page.should have_content(@team.name)

	end

	it "will ask you to log in if you haven't, when you scan a tag" do

	end




end