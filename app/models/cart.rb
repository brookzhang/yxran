class Cart < ActiveRecord::Base
  belongs_to :store
  belongs_to :product
  belongs_to :user
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :store_id, :quantity, :unit_price, :amount, :discount, :score, :user_id 

  
  validates_presence_of :product_id, :store_id, :quantity  , :user_id 
  #validates_uniqueness_of :product_id, :scope => :store_id
  
  
  def self.count_by_user(user)
    list_by_user(user).count
  end
  
  def self.list_by_user(user)
    self.where(" user_id = ? and store_id = ? ", user.id, user.store_id)
  end
  
  
  
end
