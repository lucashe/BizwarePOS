class AddStoreBranchIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :store_branch_id, :integer
  end
end
