class AddExpiresDateToGame < ActiveRecord::Migration
  def change
  	add_column :games, :paymentExpires, :date
  end
end
