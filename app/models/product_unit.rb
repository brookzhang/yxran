class ProductUnit < ActiveRecord::Base
  has_many :products
  
  
  attr_accessible :name, :unit_type, :unit_count
end
