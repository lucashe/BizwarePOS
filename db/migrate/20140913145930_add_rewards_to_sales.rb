class AddRewardsToSales < ActiveRecord::Migration
  def change
    add_column :sales, :rewards_earned, :decimal, precision: 8, scale: 2
    add_column :sales, :rewards_used, :decimal, precision: 8, scale: 2
  end
end
