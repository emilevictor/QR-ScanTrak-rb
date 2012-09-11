class Tag < ActiveRecord::Base
 	attr_accessible :address, :content, :createdBy, :latitude, :longitude,
 	 :name, :quizAnswer, :points, :quizQuestion, :uniqueUrl
	geocoded_by :address
	belongs_to :user

	#has_and_belongs_to_many :teams
	has_many :scans, :dependent => :destroy

 	validates :uniqueUrl, :uniqueness => true
 	validates :points, :presence => true
 	validates :quizQuestion, :presence => true
 	validates :quizAnswer, :presence => true

 	after_validation :geocode
end
