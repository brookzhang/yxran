class Cart < ActiveRecord::Base
  belongs_to :store
  belongs_to :product
  belongs_to :user
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :store_id, :quantity, :amount, :used_score, :user_id 

  
  validates_presence_of :product_id, :store_id, :quantity, :amount , :user_id 
  #validates_uniqueness_of :product_id, :scope => :store_id
  
  
  
  
  
end
