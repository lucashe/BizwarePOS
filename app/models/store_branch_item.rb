class StoreBranchItem < ActiveRecord::Base
  belongs_to :store_branch
  belongs_to :item

end
