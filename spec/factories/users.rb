FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

	factory :UQGame, class: Game do
		name "UQ Stalkerspace"
		organisation "UQ"
		shortID "UQGAME"
		showGameInfoOnPrintedTags true
		showLogoOnPrintedTags true
		showPasswordOnPrintedTags true
		addQRScanTrakLogoOnPrintedTags true
	end

	factory :otherGame, class: Game do
		name "Some other game"
		organisation "Someone Else"
		showGameInfoOnPrintedTags true
		showLogoOnPrintedTags true
		showPasswordOnPrintedTags true
		addQRScanTrakLogoOnPrintedTags true
	end


	factory :user, class: User do
		first_name                  "FNAME"
  		last_name					"LNAME"
		sequence(:email) { |n| "Banoo.Smith#{n}@gmail.com" }
  		password              		"password"
  		password_confirmation 		"password"
  		admin false
	end

	factory :user2, class: User do
		first_name                  "FNAME"
  		last_name					"LNAME"
		email						"testemail@gmail.com"
  		password              		"password"
  		password_confirmation 		"password"
  		admin false
	end



	factory :adminUser, class: User do
		first_name "Emile"
		last_name "Victor"
		email "emilevictor@gmail.com"
		password "password"
		password_confirmation "password"
		admin true
	end

	factory :userInAGameNoTeam, class: User do



	end

	factory :team, class: Team do
		#Put this team in the UQ game.
		name "My Team"
		password "password"
		description "Description"

	end



end