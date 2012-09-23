FactoryGirl.define do

	factory :tag, class: Tag do
		association :game, factory: :UQGame
		uniqueUrl "wcunouwercoiuwenrklljlk"
		points 323
	end

end