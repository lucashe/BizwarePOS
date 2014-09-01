class Store < ActiveRecord::Base
  has_many :store_branches
  has_many :users, :through => :store_branches, :uniq => true

#has_many :user_employments
#has_many :users, through: :user_employments, :uniq => true 

end
