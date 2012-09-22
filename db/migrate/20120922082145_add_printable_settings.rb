class AddPrintableSettings < ActiveRecord::Migration
  def change
  	add_column :games, :showGameInfoOnPrintedTags, :boolean, :default => false
  	add_column :games, :showLogoOnPrintedTags, :boolean, :default => false
  	add_column :games, :showPasswordOnPrintedTags, :boolean, :default => false
  	add_column :games, :addQRScanTrakLogoOnPrintedTags, :boolean, :default => false
  end
end
