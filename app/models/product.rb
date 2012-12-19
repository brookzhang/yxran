class Product < ActiveRecord::Base
  has_many :stocks
  has_many :sales

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :description, :category, :measurement, :unit_price, :status

  
  validates_presence_of :name, :measurement
  validates_uniqueness_of :name, :case_sensitive => false
end
