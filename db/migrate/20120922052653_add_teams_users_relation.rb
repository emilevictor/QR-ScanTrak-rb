class AddTeamsUsersRelation < ActiveRecord::Migration
def change
  	create_table :teams_users, :id => false do |t|
	  t.references :team, :null => false
	  t.references :user, :null => false
	end

	# Adding the index can massively speed up join tables. Don't use the
	# unique if you allow duplicates.
	add_index(:teams_users, [:team_id, :user_id], :unique => true)
  end
end