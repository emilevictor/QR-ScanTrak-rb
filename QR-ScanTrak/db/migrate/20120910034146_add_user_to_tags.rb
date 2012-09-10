class AddUserToTags < ActiveRecord::Migration
  def change
    add_column :tags, :createdByUser_id, :integer
  end
end
