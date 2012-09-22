class AddGameIdToTags < ActiveRecord::Migration
  def change
  	add_column :tags, :game_id, :integer
  end
end
