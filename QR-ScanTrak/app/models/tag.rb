class Tag < ActiveRecord::Base
  attr_accessible :QRCode, :address, :content, :createdBy, :latitude, :longitude, :name, :quizAnswer, :quizQuestion, :unique, :uniqueUrl
end
