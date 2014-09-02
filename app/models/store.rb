class Store < ActiveRecord::Base
  has_many :store_branches
  has_many :users
  has_many :customers
  has_many :items

  has_many :sales, :through => :store_branches

end
