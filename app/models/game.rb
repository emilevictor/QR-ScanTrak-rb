class Game < ActiveRecord::Base
  attr_accessible :contactDetails, :description,
   :maxNumberOfPlayers, :name, :organisation,
   :paymentExpires, :requiresPassword, :password

  #When a user logs in, they will be presented with a choice of game
  #They must either visit a link which will associate them with that game
  #Or enter it into a box.

  validates_presence_of :name

  has_and_belongs_to_many :users
  has_many :tags
  has_many :scans
  has_many :teams

end
