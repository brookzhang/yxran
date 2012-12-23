class Stock < ActiveRecord::Base
  has_many :histories
  belongs_to :store
  belongs_to :product
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :store_id, :quantity, :safe_stock, :remark

  
  validates_presence_of :product_id, :store_id
  validates_uniqueness_of :product_id, :scope => :store_id
  
  def change_stock(store_id, product_id, quantity, reference_id, remark)
    @stock = Stock.where(" store_id = ? and product_id = ? ", store_id, product_id).first
      if @stock.nil?
        @stock = Stock.new
        @stock.store_id = store_id
        @stock.product_id = product_id
        @stock.quantity = quantity
        @stock.save
      else
        @stock.quantity += quantity
        @stock.update_attributes(:quantity => @stock.quantity )
      end
      
      @history = History.new(:stock_id => @stock.id, :adjust_type => 'o', :reference_id => reference_id, :adjusted_by => quantity, :adjusted_to => @stock.quantity, :adjusted_at => DateTime.now , :remark => "order_add")
      @history.save
  end
  
  
  
end
