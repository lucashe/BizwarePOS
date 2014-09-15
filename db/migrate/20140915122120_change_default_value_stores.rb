class ChangeDefaultValueStores < ActiveRecord::Migration
  def change

    change_column_default :stores, :member_reward, 0
    change_column_default :stores, :member_discount, 0
    
  end
end
