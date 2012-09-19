class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :unique
      t.string :uniqueUrl
      t.string :QRCode
      t.text :quizQuestion
      t.string :quizAnswer
      t.text :content
      t.decimal :latitude
      t.decimal :longitude
      t.string :address
      t.integer :createdBy

      t.timestamps
    end
  end
end
