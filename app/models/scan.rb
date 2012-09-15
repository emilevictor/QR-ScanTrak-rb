class Scan < ActiveRecord::Base
  attr_accessible :tag_id, :team_id
  belongs_to :team #requires has_many :scans on team
  has_many :users, :through => :team
  belongs_to :tag #requires has_many :scans on tag


end
