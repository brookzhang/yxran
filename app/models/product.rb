class Product < ActiveRecord::Base
  has_many :stocks

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :description, :category, :measurement, :unit_price

  
  validates_presence_of :name, :measurement
  validates_uniqueness_of :name, :case_sensitive => false
end
