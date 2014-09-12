class AddRewardPolicyToStore < ActiveRecord::Migration
  def change

    add_column :stores, :enable_member, :boolean , :default => false
    add_column :stores, :member_discount, :integer
    add_column :stores, :member_reward, :integer

  end
end
