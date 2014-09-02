class CreateStoreBranchItems < ActiveRecord::Migration
  def change
    create_table :store_branch_items do |t|

      t.integer :store_branch_id
      t.integer :item_id

      t.timestamps

    end
  end
end
