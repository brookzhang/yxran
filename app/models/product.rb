class Product < ActiveRecord::Base
  has_many :stocks
  has_many :sale_details
  has_many :order_details
  has_many :transfer_details
  has_many :inventory_details
  
  belongs_to :category
  belongs_to :measurement
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :description, :category_id, :measurement_id, :default_price, :super_category_id
  
  attr_accessor :category_name, :super_category_id
  
  validates_presence_of :name, :measurement_id, :category_id, :default_price
  validates_uniqueness_of :name, :case_sensitive => false
  validates_numericality_of :default_price, :greater_than => 0
  
  
  scope :by_name, lambda { |name| where("name like ? ", '%'+name+'%').order(" id desc ") if name.present? }

  scope :by_category_name, lambda { |name| where("category_id in (select id from categories where name = ? )", name).order(" id desc ") unless name.nil? || name == '' }
  scope :by_category, lambda { |super_id, category_id| category_id.to_i > 0 ? where(:category_id => category_id ).order(" id desc ") : where(:category_id => Category.sub_id_array(super_id) ).order(" id desc ") }
  scope :in_category, lambda { |category_id| where(:category_id => Category.sub_id_array(category_id) << category_id ).order(' default_price asc, id asc ') }

  
  #scope :for_sale, joins(:stocks).where(" products.category_id in ? and stocks.quantity > 0 ", Category.sub_id_array(category_id) << category_id)
  #scope :for_sale, where(:products => Category.sub_id_array(category_id) << category_id   )
  
  def discount(member_level)
    0.1
  end
  
  def unit_price(*store_id)
    if store_id
      Stock.price_of_product_in_store(self.id, store_id) || self.default_price
    else
      self.default_price
    end
  end
  
  def price(*store_id)
    self.unit_price(store_id).to_s << I18n.t("currency") << '/' << self.measurement.name
  end

  
  def self.list_with_sub_category(category_id)
    where(:category_id => Category.sub_id_array(category_id) << category_id )
    
  end
  
  def self.for_sale(category_id, store_id)
    joins(:stocks).where(:products => {:category_id => Category.sub_id_array(category_id) << category_id },
                         :stocks => {:quantity => 0..999999, :store_id => store_id})
  end
  
  
  
  def self.find_by_name(name)
    where(:name => name).first
  end
  
end
