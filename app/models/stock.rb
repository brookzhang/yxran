class Stock < ActiveRecord::Base
  has_many :histories
  belongs_to :store
  belongs_to :product
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :store_id, :quantity, :safe_stock, :remark, :adjust_type
  
  attr_accessor :adjust_type, :reference_id, :change_qty, :change_remark

  
  validates_presence_of :product_id, :store_id
  validates_uniqueness_of :product_id, :scope => :store_id
  
  
  #callbacks
  after_save :log_history
  
  
  #init stock
  def self.fetch(store_id, product_id)
    @stock = where(:store_id => store_id, :product_id => product_id).first
    @stock = new(:store_id => store_id, :product_id => product_id) if @stock.nil?
    @stock 
  end
  
  def self.exists(store_id, product_id)
    !where(:store_id => store_id, :product_id => product_id).first.nil?
  end
  
  def self.get_quantity(store_id, product_id)
    @stock = self.fetch(store_id, product_id)
    @stock.quantity.nil? ? 0 : @stock.quantity
  end
  
  
  
  protected
  
  def log_history()
    self.change_qty = self.change_qty.nil? ? 0 : self.change_qty
    self.change_qty = self.change_qty == 0 ? self.quantity : self.change_qty
    
    @history = StockHistory.new(:stock_id => self.id,
                           :adjust_type => self.adjust_type,
                           :reference_id => self.reference_id,
                           :adjusted_by => self.change_qty,
                           :adjusted_to => self.quantity,
                           :adjusted_at => DateTime.now,
                           :remark => self.change_remark)
    @history.save!
  end
  
  
end
