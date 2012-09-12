class AddPointsToTag < ActiveRecord::Migration
  def change
  	add_column :tags, :points, :integer
  end
end
