class AddTeamCreator < ActiveRecord::Migration
  def change
  	add_column :teams, :team_creator_id, :integer
  end
end
