require 'spec_helper'

describe "AdminTests" do
  
	it "allows you to mass create tags" do
		@user = FactoryGirl.create(:adminUser)
		@game = FactoryGirl.create(:UQGame)
		@user.games = [@game]
	 	@team = FactoryGirl.create(:team)
	 	@user.teams = [@team]

	 	@numberOfTags = Tag.all.count

		#Log our user in
		visit new_user_session_path
	 	fill_in 'user_email', :with => @user.email
	 	fill_in 'user_password', :with => 'password'
	 	click_button 'Sign in'

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

end
