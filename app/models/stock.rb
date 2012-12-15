class Stock < ActiveRecord::Base
  has_many :histories
  belongs_to :store, :product
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :store_id, :quantity, :safe_stock, :remark

  
  validates_presence_of :product_id, :store_id
  validates_uniqueness_of :product_id, :scope => :store_id
end
