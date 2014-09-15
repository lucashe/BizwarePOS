class Item < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  belongs_to :store
  belongs_to :item_category

  has_many :line_items
  has_many :branch_items,:dependent => :destroy
  
  has_many :branches, through: :branch_items
  accepts_nested_attributes_for :branch_items

  validates :name, :presence => true
  validates :price, :presence => true

  default_scope :order => 'id ASC'

end
