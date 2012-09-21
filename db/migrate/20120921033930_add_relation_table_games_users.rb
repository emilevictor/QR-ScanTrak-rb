class AddRelationTableGamesUsers < ActiveRecord::Migration
  def change
  	create_table :games_users, :id => false do |t|
	  t.references :game, :null => false
	  t.references :user, :null => false
	end

	# Adding the index can massively speed up join tables. Don't use the
	# unique if you allow duplicates.
	add_index(:games_users, [:game_id, :user_id], :unique => true)
  end
end
