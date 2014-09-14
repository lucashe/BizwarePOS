class ChangeCustomersIcToIc < ActiveRecord::Migration
  def change
    rename_column :customers, :IC, :ic
  end
end
