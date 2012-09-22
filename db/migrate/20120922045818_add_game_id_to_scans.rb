class AddGameIdToScans < ActiveRecord::Migration
  def change
  	add_column :scans, :game_id, :integer
  end
end
