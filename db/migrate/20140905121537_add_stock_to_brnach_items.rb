class AddStockToBrnachItems < ActiveRecord::Migration
  def change

    add_column :branch_items, :stock_amount, :integer
    add_column :branch_items, :amount_sold, :integer , default: 0

    remove_column :items, :stock_amount
    remove_column :items, :amount_sold

  end
end
