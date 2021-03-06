class Cart < ActiveRecord::Base
  belongs_to :store
  belongs_to :product
  belongs_to :user
  
  default_scope :order => "id desc"
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :store_id, :quantity, :unit_price, :amount, :discount, :score, :user_id 


  validates_presence_of :product_id, :store_id, :quantity  , :user_id 
  #validates_uniqueness_of :product_id, :scope => :store_id
  
  
  validates_numericality_of :quantity, :greater_than => 0
  validates_numericality_of :amount, :greater_than => 0

  before_save :cart_quantity_should_not_big_than_stock
  
  
  def self.count_by_user(user)
    list_by_user(user).count
  end
  
  def self.list_by_user(user)
    self.where( :user_id => user.id , :store_id => user.store_id.nil? ? 0 : user.store_id)
  end

  def price
    self.unit_price.to_s << '/' << self.product.measurement.name
  end

  def cart_quantity_should_not_big_than_stock
    sum_quantity = self.quantity

    carts = Cart.where(:product_id => self.product_id, :store_id => self.store_id, :user_id => self.user_id)
    sum_quantity += carts.map(&:quantity).sum if carts.count > 0

    Stock.get_quantity(self.store_id, self.product_id) >= sum_quantity
  end
  
  
  
end
