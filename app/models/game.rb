class Game < ActiveRecord::Base
  attr_accessible :contactDetails, :description,
   :maxNumberOfPlayers, :name, :organisation,
   :paymentExpires, :requiresPassword, :password, :showGameInfoOnPrintedTags,
   :showLogoOnPrintedTags, :showPasswordOnPrintedTags,
   :addQRScanTrakLogoOnPrintedTags, :shortID

  #When a user logs in, they will be presented with a choice of game
  #They must either visit a link which will associate them with that game
  #Or enter it into a box.

  validates_presence_of :name

  has_and_belongs_to_many :users
  has_many :tags, :dependent => :destroy
  has_many :scans, :dependent => :destroy
  has_many :teams , :dependent => :destroy

  has_and_belongs_to_many :moderators, :class_name => 'User', :join_table => 'moderators_games', :association_foreign_key => 'user_id'

end
