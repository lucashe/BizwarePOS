class Store < ActiveRecord::Base

  has_many :branches, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :item_categories, dependent: :destroy
  has_many :items, dependent: :destroy

  has_many :sales, :through => :branches
  has_many :payments, through: :sales

end
