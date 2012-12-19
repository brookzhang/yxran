class Store < ActiveRecord::Base
  has_many :stocks
  has_many :sales
  has_many :users
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :category, :remark , :status

  
  validates_presence_of :name 
  validates_uniqueness_of :name, :case_sensitive => false
end
