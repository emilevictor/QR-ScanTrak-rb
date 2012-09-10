class Team < ActiveRecord::Base
  attr_accessible :description, :name, :password

  has_many :users
  has_and_belongs_to_many :tags

  validates :name, :presence => true
  validates :password, :presence => true
  validates :description, :presence => true

end
