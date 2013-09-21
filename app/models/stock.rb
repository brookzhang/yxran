class Stock < ActiveRecord::Base
  has_many :histories
  belongs_to :store
  belongs_to :product
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :store_id, :quantity, :safe_stock, :unit_price, :remark, :adjust_category
  
  attr_accessor :adjust_category, :reference_id, :change_qty, :change_remark, :product_name

  
  validates_presence_of :product_id, :store_id
  validates_uniqueness_of :product_id, :scope => :store_id
  
  
  scope :in_store, lambda { |store_id| where( :store_id => store_id ) unless store_id.nil? || store_id == ''}
  scope :in_category, lambda { |category_id| joins(:product).where(:products => {:category_id => Category.sub_id_array(category_id) << category_id }) }
  scope :has_stock, where(" quantity > 0 ")
  
  
  scope :by_product, lambda{ |product_name| where(" product_id in (select id from products where name = ? )", product_name) if !product_name.nil? && product_name != '' }
  
  #callbacks
  after_save :log_history
  
  
  #init stock
  def self.fetch(store_id, product_id)
    stock = where(:store_id => store_id, :product_id => product_id).first
    stock = new(:store_id => store_id, :product_id => product_id) if stock.nil?
    stock 
  end
  
  def self.exists(store_id, product_id)
    !where(:store_id => store_id, :product_id => product_id).first.nil?
  end
  
  def self.get_quantity(store_id, product_id)
    stock = self.fetch(store_id, product_id)
    stock.quantity.nil? ? 0 : stock.quantity
  end
  
  def self.price_of_product_in_store(product_id, store_id)
    stock = self.find_by_product_id_and_store_id(product_id, store_id)
    stock.nil? ? nil : stock.unit_price
  end
  
  
  protected
  
  def log_history()
    self.change_qty = self.change_qty.nil? ? 0 : self.change_qty
    self.change_qty = self.change_qty == 0 ? self.quantity : self.change_qty
    
    history = StockHistory.new(:stock_id => self.id,
                           :adjust_category => self.adjust_category,
                           :reference_id => self.reference_id,
                           :adjusted_by => self.change_qty,
                           :adjusted_to => self.quantity,
                           :adjusted_at => DateTime.now,
                           :remark => self.change_remark)
    history.save!
  end
  
  
end
