class Team < ActiveRecord::Base
  attr_accessible :description, :name, :password


  has_and_belongs_to_many :users
  has_many :scans
  has_many :tags, :through => :scans

  belongs_to :game

  validates :name, :presence => true
  validates :password, :presence => true
  validates :description, :presence => true

def getTotalScore

	@scans = Scan.where(:team_id => self.id)
	scanSum = 0
	@scans.each do |scan|
		if not scan.tag.nil?
			scanSum += scan.tag.points
		end
	end

	return scanSum
end

def getNumberOfScans
	scanCount = Scan.where(:team_id => self.id).count
	return scanCount
end

def getPlacement(leaderboard)
	#leaderboard = Team.getLeaderboard()
	ourTeam = leaderboard.select {|f| f["id"] = self.id}
	placementMinusOne = leaderboard.index(ourTeam[0])
	placement = placementMinusOne + 1
	return placement
end

	#returns a sorted array of hashes, containing 
	def self.getLeaderboard(me)
		leaderboardArray = Array.new

		index = 0
		@teams = me.currentGame().teams.all

		@teams.each do |team|
			leaderboardArray[index] = {:id => team.id, :name => team.name, :score => team.getTotalScore}
			index += 1
		end

		leaderboardArray = leaderboardArray.sort_by {|hsh| hsh[:score]}.reverse

		#leaderboardArray = Array.new(leaderboardHash.size)

		#leaderboardHash.each do |lbhTeam|
		#	leaderboardArray << lbhTeam.id
		#end


		return leaderboardArray
	end

end
