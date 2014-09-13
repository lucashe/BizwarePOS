class Customer < ActiveRecord::Base

  has_many :sales
  belongs_to :store
  
  def full_name
    self.last_name+","+self.first_name
  end

end
