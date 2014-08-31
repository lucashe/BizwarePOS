class RenameStoreConfigurationsColumns < ActiveRecord::Migration
  def change

    rename_column :store_branches, :store_configuration_id, :store_id
    rename_column :user_employments, :store_configuration_id, :store_id

  end
end
