class ItemCategory < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  belongs_to :store
  has_many :items

end
