class RenameStoreBranchToBranch < ActiveRecord::Migration
  def change

    rename_table :store_branches, :branches
    rename_table :store_branch_items, :branch_items

    rename_column :sales, :store_branch_id, :branch_id
    rename_column :branch_items, :store_branch_id, :branch_id

    #add_column :customers, :id, :string

  end
end
