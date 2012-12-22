class Category < ActiveRecord::Base
  has_many :products
  has_many :discounts

  # Setup accessible (or protected) attributes for your model
  attr_accessible :parent_id, :name, :description, :sequence, :status

  
  validates_presence_of :parent_id, :name, :description
  #validates_uniqueness_of :name, :case_sensitive => false
  
  def parent
    self.parent_id.nil? || self.parent_id==0 ? Category.new(:name => 'root_category') : Category.find(self.parent_id)
  end
  
  def all_category_ids
    
  end
  
end
