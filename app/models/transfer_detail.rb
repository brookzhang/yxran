class TransferDetail < ActiveRecord::Base
  
  belongs_to :transfer
  belongs_to :product
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :transfer_id, :product_id , :quantity, :remark

  
  validates_presence_of :transfer_id, :product_id, :quantity 
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  
end
