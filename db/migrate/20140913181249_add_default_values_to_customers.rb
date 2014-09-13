class AddDefaultValuesToCustomers < ActiveRecord::Migration
  def change
    change_column_default :customers, :rewards, 0
  end
end
