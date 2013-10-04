class OrderDetail < ActiveRecord::Base
  
  belongs_to :product
  belongs_to :order
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible  :product_id , :quantity, :amount, :remark, :unit_price
  
  attr_accessor :product_name

  
  validates_presence_of  :product_id , :quantity 
  #validates_uniqueness_of :name, :case_sensitive => false
  
  validates_numericality_of :quantity, :greater_than => 0
  
   
  
end
