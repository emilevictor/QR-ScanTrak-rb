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
Scan.delete_all


# move cursor to beginning of line
cr = "\r"           


# ANSI escape code to clear line from cursor to end of line
# "\e" is an alternative to "\033"
# cf. http://en.wikipedia.org/wiki/ANSI_escape_code
clear = "\e[0K"     

# reset lines
reset = cr + clear

emile = User.create!(:email => "emilevictor@gmail.com", :password => "password", :password_confirmation => "password", :first_name => "Emile", :last_name => "Victor", :admin => true)

emile.save

if not Rails.env.production?
	

	puts "********* NOW GENERATING 110 TAGS, STAND BY ***********"
	print "          "
	for i in 0..110
		percentage = ((i.to_f/110)*100).to_i
	    string = "="*((i.to_f/110)*60).to_i.abs + " "*(60-((i.to_f/110)*60)).abs
	    print "#{reset}|#{string}| #{percentage}%"


		@newTag = Tag.new
		@newTag.name = "#{RandomWord.adjs.next} #{RandomWord.nouns.next}"
		@newTag.uniqueUrl = (0...20).map{ ('a'..'z').to_a[rand(26)] }.join

	    while (!Tag.where(:uniqueUrl => @newTag.uniqueUrl).first.nil?)
	    	@newTag.uniqueUrl = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
	    end

	    @newTag.quizQuestion = ""
	    @newTag.quizAnswer = ""

		if Rails.env.production?
			qrCodeString = "http://" + "qrscantrak.com" + "/tags/" + @newTag.uniqueUrl + "/tagFound"

		else
			qrCodeString = "http://" + "localhost:3000" + "/tags/" + @newTag.uniqueUrl + "/tagFound"
		end


	    qr_code_img = RQRCode::QRCode.new(qrCodeString, :size => 10, :level => :h ).to_img
		qr_code_img = qr_code_img.resize(320,320)
	    @newTag.update_attribute :qr_code, qr_code_img.to_string


		#@newTag.latitude = -150+rand(300)
		#@newTag.longitude = -150+rand(300)
		#@newTag.createdBy = 1
		@newTag.points = -100 + rand(500)
		#@newTag.user_id = 1

		@newTag.address = ""

		if @newTag.valid?
			@newTag.save
			emile.tags << @newTag
		else
			print @newTag.errors
		end
	end



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



end


