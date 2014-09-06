class AddStoreIdToItemCategories < ActiveRecord::Migration
  def change
    add_column :item_categories, :store_id, :integer
  end
end
