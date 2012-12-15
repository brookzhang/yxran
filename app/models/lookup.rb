class Lookup < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :code, :category, :description, :sequence, :status

  
  validates_presence_of :code, :category, :description
  #validates_uniqueness_of :name, :case_sensitive => false
end
