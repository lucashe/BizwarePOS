class RenameStoreConfigurationsToStores < ActiveRecord::Migration
  def change
    rename_table :store_configurations, :stores
  end
end
