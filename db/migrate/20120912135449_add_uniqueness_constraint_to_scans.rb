class AddUniquenessConstraintToScans < ActiveRecord::Migration
  def change
  	add_index :scans, [:tag_id, :team_id], :unique => true
  end
end
