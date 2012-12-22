class Switch < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :key, :value, :description, :status

  
  validates_presence_of :key, :value, :description
  #validates_uniqueness_of :name, :case_sensitive => false
end
