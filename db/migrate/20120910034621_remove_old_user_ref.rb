class RemoveOldUserRef < ActiveRecord::Migration
  def up
  	remove_column :tags, :createdByUser_id
  	add_column :tags, :user_id, :integer
  end

  def down
  	add_column :tags, :createdByUser_id, :integer
  	remove_column :tags, :user_id
  end
end
