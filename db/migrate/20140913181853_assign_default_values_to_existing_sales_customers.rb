class AssignDefaultValuesToExistingSalesCustomers < ActiveRecord::Migration
  def self.up
    update("update customers set rewards = 0 where rewards is null")
    update("update sales set amount = 0 where amount is null")
    update("update sales set total_amount = 0 where total_amount is null")
    update("update sales set remaining_amount = 0 where remaining_amount is null")
    update("update sales set discount = 0 where discount is null")
    update("update sales set tax = 0 where tax is null")
    update("update sales set rewards_earned = 0 where rewards_earned is null")
    update("update sales set rewards_used = 0 where rewards_used is null")
  end
end
