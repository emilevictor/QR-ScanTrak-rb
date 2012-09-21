class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :organisation
      t.integer :maxNumberOfPlayers
      t.text :contactDetails
      t.text :description

      t.timestamps
    end
  end
end
