class Customer < ActiveRecord::Base

  has_many :sales
  belongs_to :store

end
