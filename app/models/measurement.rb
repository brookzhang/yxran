class Measurement < ActiveRecord::Base
  has_many :products
  
  
  attr_accessible :name, :measurement, :unit_count
end
