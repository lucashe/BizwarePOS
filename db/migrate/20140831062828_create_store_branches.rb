class CreateStoreBranches < ActiveRecord::Migration
  def change
    create_table :store_branches do |t|

      t.integer :store_configuration_id
      t.string :branch_name
      t.text :branch_description
      t.string :email_address
      t.string :phone_number
      t.string :website_url
      t.string :addr_floor
      t.string :addr_unit
      t.string :addr_block
      t.string :addr_street
      t.string :addr_building
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end

    add_column :store_configurations, :store_branch_id, :integer

  end
end
