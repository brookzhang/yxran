class TransferDetail < ActiveRecord::Base
  
  belongs_to :transfer
  belongs_to :product
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :transfer_id, :product_id , :quantity, :remark

  
  validates_presence_of :transfer_id, :product_id, :quantity 
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  def self.get_quantity(transfer_id, product_id)
    @quantity =self.where(:transfer_id => transfer_id, :product_id => product_id).sum{|d| d.quantity}
    @quantity.nil? ? 0 : @quantity
  end
  
end
