class RemoveUniqueFromTags < ActiveRecord::Migration
  def up
  	remove_column :tags, :unique
  end

  def down
  	add_column :tags, :unique, :string
  end
end
