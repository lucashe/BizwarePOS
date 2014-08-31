class Store < ActiveRecord::Base
  has_many :store_branches

  has_many :user_employments
  has_many :users, through: :user_employments

end
