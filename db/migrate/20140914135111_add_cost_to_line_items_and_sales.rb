class AddCostToLineItemsAndSales < ActiveRecord::Migration
  def change

    add_column :sales, :cost, :decimal, precision: 8, scale: 2, default: 0.0

    add_column :line_items, :cost, :decimal, precision: 8, scale: 2
    add_column :line_items, :total_cost, :decimal, precision: 8, scale: 2

  end
end
