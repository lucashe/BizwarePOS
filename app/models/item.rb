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

  filterrific(
    filter_names: [
      :search_query,
      :with_item_category_id
    ]
  )

  scope :search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 1
    where(
      terms.map {
        or_clauses = [
          "LOWER(items.name) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  scope :with_item_category_id, lambda { |item_category_ids|
    where(:item_category_id => [*item_category_ids])
  }

#delegate :name, :to => :item_category, :prefix => true

end
