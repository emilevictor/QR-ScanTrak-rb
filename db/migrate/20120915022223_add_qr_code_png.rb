class AddQrCodePng < ActiveRecord::Migration
  def change
  	add_column :tags, :qr_code_uid,  :string
	add_column :tags, :qr_code_name, :string

  end
end
