class Product < ActiveRecord::Base
  has_many :stocks
  has_many :sale_details
  has_many :order_details
  has_many :transfer_details
  
  belongs_to :category

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :description, :category_id, :measurement, :unit_price, :status

  
  validates_presence_of :name, :measurement
  validates_uniqueness_of :name, :case_sensitive => false
  
  #scope :for_sale, joins(:stocks).where(" products.category_id in ? and stocks.quantity > 0 ", Category.sub_id_array(category_id) << category_id)
  #scope :for_sale, where(:products => Category.sub_id_array(category_id) << category_id   )
  
  def discount(member_level)
    0.1
  end
  
  def price
    self.unit_price.to_s << '/' << self.measurement
  end
  
  def self.list_with_sub_category(category_id)
    where(:category_id => Category.sub_id_array(category_id) << category_id )
    
  end
  
  def self.for_sale(category_id, store_id)
    joins(:stocks).where(:products => {:category_id => Category.sub_id_array(category_id) << category_id },
                         :stocks => {:quantity => 0..999999, :store_id => store_id})
  end
end
