class Order < ActiveRecord::Base
  has_many :histories
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :product_id , :quantity, :amount, :remark, :status, :user_id

  
  validates_presence_of :store_id, :product_id , :quantity, :amount 
  #validates_uniqueness_of :name, :case_sensitive => false
end
