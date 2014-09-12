class Branch < ActiveRecord::Base
  belongs_to :store

  has_many :user_employments, dependent: :destroy
  has_many :users, through: :user_employments

  has_many :branch_items, dependent: :destroy
  has_many :items, through: :branch_items

  has_many :sales, dependent: :destroy
  has_many :payments, through: :sales

end
