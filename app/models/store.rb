class Store < ActiveRecord::Base
  has_many :branches
  has_many :users
  has_many :customers
  has_many :item_categories
  has_many :items

  has_many :sales, :through => :branches

end
