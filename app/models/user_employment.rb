class UserEmployment < ActiveRecord::Base
  belongs_to :store_branch
  #belongs_to :store
  belongs_to :user

end
