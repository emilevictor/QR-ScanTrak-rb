class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.string :password
      t.integer :user_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
