class AddIsFinalToSales < ActiveRecord::Migration
  def change
    add_column :sales, :is_final, :boolean , default: false
  end
end
