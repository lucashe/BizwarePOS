class Branch < ActiveRecord::Base
  belongs_to :store

  has_many :user_employments
  has_many :users, through: :user_employments

  has_many :branch_items
  has_many :items, through: :branch_items

  has_many :sales

end
