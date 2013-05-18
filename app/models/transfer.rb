class Transfer < ActiveRecord::Base
  belongs_to :from_store, :class_name => 'Store'
  belongs_to :to_store, :class_name => 'Store'
  belongs_to :product
  belongs_to :transferer, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  has_many :transfer_details

  # Setup accessible (or protected) attributes for your model
  attr_accessible :from_store_id, :to_store_id, :transfer_remark, :receive_remark, :transferer_id  ,:receiver_id
  # status 0-temp, 1-transfered , 2-received, 3-partial received , 9-cancel 
  
  validates_presence_of :from_store_id, :to_store_id 
  #validates_uniqueness_of :name, :case_sensitive => false
  
  def is_ok_to_transfer?
    @is_stock_is_enough = true
    @transfer_details = TransferDetail.where(:transfer_id => self.id)
    @transfer_details.each do |d|
      if d.quantity > Stock.get_quantity(self.from_store_id, d.product_id)
        @is_stock_is_enough = false
      end
    end
    @is_stock_is_enough
  end
  
  def transfer
    @transfer_details = TransferDetail.where(:transfer_id => self.id)
    
    begin
      self.transaction do
        #update status to transfered
        self.status = 1
        self.transfered_at = DateTime.now()
        self.save!
        
        #update stock
        @transfer_details.each do |d|
          @stock = Stock.fetch(self.from_store_id, d.product_id)
          @stock.quantity = @stock.quantity.nil? ? 0 : @stock.quantity
          @stock.quantity += d.quantity * (-1)
          @stock.adjust_type = 'T'
          @stock.reference_id = d.id
          @stock.change_qty = d.quantity  * (-1)
          #@stock.change_remark = self.remark
          @stock.save!
        end
      end
      true
    rescue => err
      logger.error "****************************"  
      logger.error "#{err.message}"  
      #logger.error "#{err.backtrace.join('\n')}"  
      logger.error "****************************"  
      #logger.debug "======= error output: " + err.to_s 
      #self.check_message = 'unable_to_receive'
      false
    end
  end
  
  
  def receive
    @transfer_details = TransferDetail.where(:transfer_id => self.id)
    
    begin
      self.transaction do
        #update status to received
        self.status = 2
        self.received_at = DateTime.now()
        self.save!
        
        #update stock
        @transfer_details.each do |d|
          @stock = Stock.fetch(self.to_store_id, d.product_id)
          @stock.quantity = @stock.quantity.nil? ? 0 : @stock.quantity
          @stock.quantity += d.quantity 
          @stock.adjust_type = 'T'
          @stock.reference_id = d.id
          @stock.change_qty = d.quantity 
          #@stock.change_remark = self.remark
          @stock.save!
        end
      end
      true
    rescue => err
      logger.error "****************************"  
      logger.error "#{err.message}"  
      #logger.error "#{err.backtrace.join('\n')}"  
      logger.error "****************************"  
      #logger.debug "======= error output: " + err.to_s 
      #self.check_message = 'unable_to_receive'
      false
    end
    
  end
  
  
  
  
  def is_owned_by?(agent)
    self.transferer_id == agent.id
  end
  
  
  def is_receiver?(user)
    self.to_store_id == user.store_id
  end
  
end
