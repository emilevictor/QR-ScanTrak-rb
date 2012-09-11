# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


for i in 0..2000
	@newTag = Tag.new
	@newTag.name = RandomWord.adjs.next + ' ' + RandomWord.nouns.next
	@newTag.uniqueUrl = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
	@newTag.content = (RandomWord.adjs.next + ' ' + RandomWord.nouns.next)*32
	@newTag.latitude = -150+rand(300)
	@newTag.longitude = -150+rand(300)
	@newTag.createdBy = 1
	@newTag.points = -100 + rand(500)
	@newTag.user_id = 1
	@newTag.save
end