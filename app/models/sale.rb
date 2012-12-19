class Sale < ActiveRecord::Base
  has_many :histories
  
  belongs_to :store
  belongs_to :product
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :product_id, :member_id , :remark, :category, :quantity, :amount, :score, :status, :user_id

  
  validates_presence_of :store_id, :product_id, :quantity
  #validates_uniqueness_of :name, :case_sensitive => false
end
