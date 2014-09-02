class StoreBranch < ActiveRecord::Base
  belongs_to :store

  has_many :user_employments
  has_many :users, through: :user_employments

  has_many :store_branch_items
  has_many :items, through: :store_branch_items

  has_many :sales

end
