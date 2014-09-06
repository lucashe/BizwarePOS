class CleanColumns < ActiveRecord::Migration
  def change

    remove_column :stores, :store_branch_id
    remove_column :users, :roles_mask

    rename_column :user_employments, :store_branch_id, :branch_id

  end
end
