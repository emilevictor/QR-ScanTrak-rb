class AddShortIdToGame < ActiveRecord::Migration
  def change
  	add_column :games, :shortID, :string
  end
end
