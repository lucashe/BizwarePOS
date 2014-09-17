class ItemCategory < ActiveRecord::Base

  validates :name, :presence => true

  belongs_to :store
  has_many :items
  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end

end
