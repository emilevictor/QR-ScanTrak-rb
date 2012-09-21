class AddPasswordsToGames < ActiveRecord::Migration
  def change
  	add_column :games, :requiresPassword, :boolean
  end
end
