class CreateJoinBetweenTeamsAndTags < ActiveRecord::Migration
  def up
	create_table 'tags_teams', :id => false do |t|
		t.column :team_id, :integer
		t.column :tag_id, :integer
	end
  end

  def down
  	drop_table 'tags_teams'
  end
end
