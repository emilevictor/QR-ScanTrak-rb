class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.integer :team_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
