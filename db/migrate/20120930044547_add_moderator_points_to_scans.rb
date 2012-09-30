class AddModeratorPointsToScans < ActiveRecord::Migration
  def change
  	add_column :scans, :modPoints, :integer
  	add_column :scans, :thisIsAPointModification, :boolean, :default => false
  end
end
