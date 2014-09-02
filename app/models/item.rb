class Item < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  belongs_to :item_category
  belongs_to :store

  has_many :line_items

  has_many :store_branch_items
  has_many :store_branches, through: :store_branch_items

  validates :sku, :presence => true, :uniqueness => true
  validates :name, :presence => true, :uniqueness => true
  validates :price, :presence => true
  validates :stock_amount, :presence => true

  default_scope :order => 'sku ASC'
end
