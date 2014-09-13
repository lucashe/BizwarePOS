class AddDefaultValuesToSales < ActiveRecord::Migration
  def change

    change_column_default :sales, :amount, 0
    change_column_default :sales, :total_amount, 0
    change_column_default :sales, :remaining_amount, 0
    change_column_default :sales, :discount, 0
    change_column_default :sales, :tax, 0
    change_column_default :sales, :rewards_earned, 0
    change_column_default :sales, :rewards_used, 0

  end
end
