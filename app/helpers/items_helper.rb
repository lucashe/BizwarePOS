module ItemsHelper
  def get_store_stock_amount(store,item)
    item.branch_items.sum(:stock_amount)
  end

  def get_store_amount_sold(store,item)
    item.branch_items.sum(:amount_sold)
  end

  def get_branch_stock_amount(branch,item)
    BranchItem.where(:branch_id => branch.id, :item_id => item.id).stock_amount
  end

  def get_branch_amount_sold(branch,item)
    BranchItem.where(:branch_id => branch.id, :item_id => item.id).amount_sold
  end

end