class Transfer < ActiveRecord::Base
  has_many :histories
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :from_store_id, :to_store_id, :product_id , :quantity, :remark, :status, :user_id

  
  validates_presence_of :from_store_id, :to_store_id, :product_id , :quantity 
  #validates_uniqueness_of :name, :case_sensitive => false
end
