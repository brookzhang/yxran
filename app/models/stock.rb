class Stock < ActiveRecord::Base
  has_many :histories
  belongs_to :store
  belongs_to :product
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :store_id, :quantity, :safe_stock, :remark

  
  validates_presence_of :product_id, :store_id
  validates_uniqueness_of :product_id, :scope => :store_id
  
  
  #init stock
  
  
  
  #common method ,update stock
  def record_update(quantity, history)
    if quantity == 0
      return
    else
      if self.id.nil?
        self.quantity = quantity
      else
        self.quantity += quantity
      end
      
      self.save
      
      history.stock_id = self.id
      history.adjusted_by = quantity
      history.adjusted_to = self.quantity
      history.adjusted_at = DateTime.now
      history.save
    end
    
    
    
  end
  
  
  
end
