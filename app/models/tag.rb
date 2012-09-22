class Tag < ActiveRecord::Base
	image_accessor :qr_code

	
 	attr_accessible :address, :content, :createdBy, :latitude, :longitude,
 	 :name, :quizAnswer, :points, :quizQuestion, :uniqueUrl
	geocoded_by :address
	belongs_to :user, :autosave => true
  	belongs_to :game, :autosave => true

	validates_presence_of :user


	#has_and_belongs_to_many :teams
	has_many :scans, :dependent => :destroy
	has_many :teams, :through => :scans

 	validates :uniqueUrl, :uniqueness => true
 	validates :uniqueUrl, :presence => true
 	validates :points, :presence => true

 	after_validation :geocode


end
