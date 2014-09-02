class ModifyUserEmployments < ActiveRecord::Migration
  def change

    remove_column :user_employments, :store_id

    add_column :users, :store_id, :integer

  end
end
