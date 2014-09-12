class AddRewardsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :IC, :string
    add_column :customers, :rewards, :decimal, precision: 8, scale: 2
    add_column :customers, :status, :string
  end
end
