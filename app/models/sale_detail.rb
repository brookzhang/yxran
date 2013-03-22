class SaleDetail < ActiveRecord::Base
  has_many :histories
  
  belongs_to :sale
  belongs_to :product
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :sale_id, :product_id, :remark, :quantity,:unit_price, :amount, :discount, :score, :status

  
  validates_presence_of :product_id, :quantity
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  
  
  
end
