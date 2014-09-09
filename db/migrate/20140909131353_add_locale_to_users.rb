class AddLocaleToUsers < ActiveRecord::Migration
  def change

    add_column :users, :locale, :string
    add_column :users, :IC, :string

  end
end
