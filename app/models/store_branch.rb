class StoreBranch < ActiveRecord::Base
  belongs_to :store

  has_many :user_employments
  has_many :users, through: :user_employments

end
