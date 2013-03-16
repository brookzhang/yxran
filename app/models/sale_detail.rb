class Sale < ActiveRecord::Base
  has_many :histories
  
  belongs_to :product
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :remark, :quantity,:unit_price, :amount, :score, :status

  
  validates_presence_of :product_id, :quantity
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  
  
  
  
end
