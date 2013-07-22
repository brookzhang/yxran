class Measurement < ActiveRecord::Base
  has_many :products

  validates_presence_of :name, :measurement, :unit_count
  validates_numericality_of :unit_count
  
  
  attr_accessible :name, :measurement, :unit_count
end
