class Order < ActiveRecord::Base
  
  belongs_to :store
  belongs_to :user
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id , :remark, :status, :user_id
  #status 0-prepare, 1-ordered, 9-canceled
  
  attr_accessor :check_message
  
  validates_presence_of :store_id , :remark
  #validates_uniqueness_of :name, :case_sensitive => false
  


  def number
    I18n.t(:order) + '#'+ ("%05d" % self.id)
  end
  
  
  def order_confirm
    ActiveRecord::Base.transaction do
      begin
        self.status = 1
        self.save
        
        @order_details = OrderDetail.where(:order_id => self.id )
        @order_details.each do |d|
          @stock = Stock.fetch(self.store_id, d.product_id)
          @stock.quantity = @stock.quantity.nil? ? 0 : @stock.quantity
          @stock.quantity += d.quantity 
          @stock.adjust_category = 'O'
          @stock.reference_id = d.id
          @stock.change_qty = d.quantity 
          @stock.unit_price = d.unit_price if d.unit_price.present? && @stock.product.unit_price !=  d.unit_price
          @stock.save!
        end
        
        true
      rescue => err
        logger.error "****************************"  
        logger.error "#{err.message}"  
        #logger.error "#{err.backtrace.join('\n')}"  
        logger.error "****************************"  
        #logger.debug "======= error output: " + err.to_s 
        self.check_message = 'unable_to_confirm'
        false
      end
    end
  end
  
  
  
  
  #*************************
  # for owner, could cancel order
  #*************************
  def cancel
    if !is_ok_to_cancel?
      return false
    end
    
    ActiveRecord::Base.transaction do
      begin
        self.status = 9
        self.save
        
        @order_details = OrderDetail.where(:order_id => self.id )
        @order_details.each do |d|
          @stock = Stock.fetch(self.store_id, d.product_id)
          @stock.quantity = @stock.quantity.nil? ? 0 : @stock.quantity
          @stock.quantity -= d.quantity 
          @stock.adjust_category = 'O'
          @stock.reference_id = d.id
          @stock.change_qty = d.quantity * (-1)
          @stock.save!
        end
        
        true
      rescue => err
        logger.error "****************************"  
        logger.error "#{err.message}"  
        #logger.error "#{err.backtrace.join('\n')}"  
        logger.error "****************************"  
        #logger.debug "======= error output: " + err.to_s 
        self.check_message = 'unable_to_cancel'
        false
      end
      
    end
  end
  
  
  
  def is_owned_by?(agent)
    self.user == agent
  end
  
  
  private
  def is_ok_to_cancel?
    self.check_message = 'pass'
    @order_details = OrderDetail.where(:order_id => self.id )
    @order_details.each do |d|
      if d.quantity > Stock.get_quantity(self.store_id, d.product_id) 
        self.check_message = 'not_enough_balance_to_cancel' if self.check_message == 'pass' 
      end
    end
    
    self.check_message == 'pass'  
  end
  
end
