class Team < ActiveRecord::Base
  attr_accessible :description, :name, :password


  has_and_belongs_to_many :users
  has_many :scans
  has_many :tags, :through => :scans

  belongs_to :game

  validates :name, :presence => true
  validates :password, :presence => true
  validates :description, :presence => true
  validates_length_of :name, :maximum => 35, :message => "Your team name is longer than 35 characters, shorten it up a bit."

def getTotalScore

	@scans = Scan.where(:team_id => self.id)
	scanSum = 0
	@scans.each do |scan|
		if not scan.tag.nil?
			scanSum += scan.tag.points
		elsif scan.thisIsAPointModification and not scan.modPoints.nil?
			scanSum += scan.modPoints
		end
	end

	return scanSum
end

def getNumberOfScans
	scanCount = Scan.where(:team_id => self.id).count
	return scanCount
end

def getPlacement(leaderboard)


	leaderboard.each do |team|
		if team[:team_id] == self.id
			return team[:placement]
		end
	end

end

def tiedWith(leaderboard)
	leaderboard.each do |team|
		if team[:team_id] == self.id
			return team[:tiedWith]
		end
	end
end

	#returns a sorted array of hashes, containing 
	def self.getLeaderboard(me)
		leaderboardArray = Array.new

		index = 0
		@teams = me.currentGame().teams.all

		@teams.each do |team|
			leaderboardArray[index] = {:team_id => team.id, :name => team.name, :score => team.getTotalScore}
			index += 1
		end

		leaderboardArray = leaderboardArray.sort_by {|hsh| hsh[:score]}.reverse

		placement = 1

		#Provide placements (including ties)
		for i in 0...leaderboardArray.length
			if i == 0
				leaderboardArray[i][:placement] = placement
				next
			end
			if leaderboardArray[i-1][:score] == leaderboardArray[i][:score]
				leaderboardArray[i][:placement] = placement
				leaderboardArray[i][:tiedWith] = leaderboardArray[i-1][:team_id]
				leaderboardArray[i-1][:tiedWith] = leaderboardArray[i][:team_id]
			else
				placement = placement + 1
				leaderboardArray[i][:placement] = placement
			end

		end

		#leaderboardArray = Array.new(leaderboardHash.size)

		#leaderboardHash.each do |lbhTeam|
		#	leaderboardArray << lbhTeam.id
		#end


		return leaderboardArray
	end

end
