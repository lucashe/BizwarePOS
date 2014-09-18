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

  filterrific(
    filter_names: [
      :sorted_by,
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

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^name_/
      order("LOWER(items.name) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  def self.options_for_sorted_by
    [
      ['Product (a-z)', 'name_asc'],
      ['Product (z-a)', 'name_desc']
    ]
  end

end
