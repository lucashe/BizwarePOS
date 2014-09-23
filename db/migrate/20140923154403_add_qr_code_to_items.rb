class AddQrCodeToItems < ActiveRecord::Migration
  def change
    add_column :items, :qr_code_uid, :text
    add_column :items, :qr_code_name, :text
  end
end
