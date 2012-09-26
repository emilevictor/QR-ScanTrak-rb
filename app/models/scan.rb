class Scan < ActiveRecord::Base
  attr_accessible :tag_id, :team_id, :comment
  belongs_to :team #requires has_many :scans on team
  has_many :users, :through => :team
  belongs_to :user, :autosave => true
  belongs_to :tag, :autosave => true #requires has_many :scans on tag
  belongs_to :game, :autosave => true


end
