class CreateUserEmployments < ActiveRecord::Migration
  def change
    create_table :user_employments do |t|

      t.integer :user_id
      t.integer :store_configuration_id
      t.integer :store_branch_id

      t.timestamps
    end
  end
end
