class Tag < ActiveRecord::Base
 	attr_accessible :address, :content, :createdBy, :latitude, :longitude, :name, :quizAnswer, :quizQuestion, :uniqueUrl
	geocoded_by :address
	belongs_to :user

	has_and_belongs_to_many :teams

 	validates :unique, :uniqueUrl, :uniqueness => true

 	after_validation :geocode
end
