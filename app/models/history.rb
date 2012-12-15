class History < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :stock_id, :adjust_type, :reference_id, :adjusted_by, :adjusted_to, :adjusted_at, :remark

  
  validates_presence_of :stock_id, :adjust_type, :adjusted_by, :adjusted_to, :adjusted_at
  #validates_uniqueness_of :product_id, :scope => :store_id
end
