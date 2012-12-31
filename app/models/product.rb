class Product < ActiveRecord::Base
  has_many :stocks
  has_many :sales
  has_many :orders
  
  belongs_to :category

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :description, :category_id, :measurement, :unit_price, :status

  
  validates_presence_of :name, :measurement
  validates_uniqueness_of :name, :case_sensitive => false
  
  def get_discount(member_level)
    0.1
  end
  
  def price
    self.unit_price.to_s << '/' << self.measurement
  end
  
end
