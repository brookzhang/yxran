class OrderDetail < ActiveRecord::Base
  
  belongs_to :product
  belongs_to :order
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible  :product_id , :quantity, :amount, :remark
  
  attr_accessor :product_name

  
  validates_presence_of  :product_id , :quantity 
  #validates_uniqueness_of :name, :case_sensitive => false
  
   
  
end