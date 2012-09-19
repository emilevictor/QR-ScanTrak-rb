class AddCommentsToScans < ActiveRecord::Migration
  def change
  	add_column :scans, :comment, :text
  	add_column :scans, :user_id, :integer
  end
end
