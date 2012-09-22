class AddDefaultGameToUser < ActiveRecord::Migration
  def change
  	add_column :users, :default_game_id, :integer
  end
end
