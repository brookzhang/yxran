class Store < ActiveRecord::Base
  has_many :stocks
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :category, :remark 

  
  validates_presence_of :name 
  validates_uniqueness_of :name, :case_sensitive => false
end
