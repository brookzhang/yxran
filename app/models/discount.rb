class Discount < ActiveRecord::Base
  belongs_to :category

  # Setup accessible (or protected) attributes for your model
  attr_accessible :category_id, :member_level, :discount

  
  validates_presence_of :category_id, :member_level, :discount
  validates_uniqueness_of :category_id, :scope => :member_level 
end
