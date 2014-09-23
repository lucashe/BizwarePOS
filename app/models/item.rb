class Item < ActiveRecord::Base

  mount_uploader :image, ImageUploader
  dragonfly_accessor :qr_code

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
    terms = query.to_s.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      ('%' + e.to_s + '%').gsub(/%+/, '%')
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
    when /^price_/
      order("items.price #{ direction }")
    when /^sold_/
      joins(:branch_items).select("sku,item_category_id,name,price,items.id,image,qr_code_uid,qr_code_name,sum(branch_items.amount_sold) as amount_sold").
      group("sku,item_category_id,name,price,items.id,image,qr_code_uid,qr_code_name").order("amount_sold #{ direction }")
    when /^stock_/
      joins(:branch_items).select("sku,item_category_id,name,price,items.id,image,qr_code_uid,qr_code_name,sum(branch_items.stock_amount) as stock_amount").
      group("sku,item_category_id,name,price,items.id,image,qr_code_uid,qr_code_name").order("stock_amount #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  
  def self.options_for_sorted_by
    [
      ['Product (a-z)', 'name_asc'],
      ['Product (z-a)', 'name_desc'],
      ['Sold (least-most)', 'sold_asc'],
      ['Sold (most-least)', 'sold_desc'],
      ['Stock (least-most)', 'stock_asc'],
      ['Stock (most-least)', 'stock_desc'],
      ['Price (lowest-highest)', 'price_asc'],
      ['Price (highest-lowest)', 'price_desc']
    ]
  end

  def generate_sku
    self.sku = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Item.exists?(sku: random_token)
    end
  end

end
