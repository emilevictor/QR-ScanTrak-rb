# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'bcrypt'

Team.delete_all
Tag.delete_all
User.delete_all

for i in 0..2000
	@newTag = Tag.new
	@newTag.name = RandomWord.adjs.next + ' ' + RandomWord.nouns.next
	@newTag.uniqueUrl = (0...20).map{ ('a'..'z').to_a[rand(26)] }.join
	@newTag.latitude = -150+rand(300)
	@newTag.longitude = -150+rand(300)
	@newTag.createdBy = 1
	@newTag.points = -100 + rand(500)
	@newTag.user_id = 1
	@newTag.save
end

emile = User.create!(:email => "emilevictor@gmail.com", :password => "password", :password_confirmation => "password", :first_name => "Emile", :last_name => "Victor", :admin => true)

emile.save

for i in 0..500

	user = User.create!(:email => "#{RandomWord.adjs.next}#{RandomWord.adjs.next}@gmail.com",:password => 'ohhai124124', :password_confirmation => 'ohhai124124', :first_name => "#{RandomWord.nouns.next.gsub("_"," ")}", :last_name => "#{RandomWord.nouns.next.gsub("_"," ")}")
	if user.save
		puts "new user created"
	else
		puts user.errors
	end
end


for i in 0..100
	@team1 = Team.new(:name => "The #{RandomWord.adjs.next.gsub("_"," ")} #{RandomWord.nouns.next.gsub("_"," ").pluralize}".capitalize, :password=>BCrypt::Password.create("HI"), :description => "hello")
	@team1.users << User.find(User.first.id+rand(400))
	@team1.users << User.find(User.first.id+rand(400))
	@team1.users << User.find(User.first.id+rand(400))
	@team1.users << User.find(User.first.id+rand(400))
	@team1.save
end


