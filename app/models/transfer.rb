class Transfer < ActiveRecord::Base
  has_many :histories
  
  belongs_to :from_store, :class_name => 'Store'
  belongs_to :to_store, :class_name => 'Store'
  belongs_to :product
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :from_store_id, :to_store_id, :product_id , :quantity, :remark, :status, :user_id

  
  validates_presence_of :from_store_id, :to_store_id, :product_id , :quantity 
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  
  def transfer_add()
    
    update_stock(self.quantity, 't')
  end
  
  
  
  def transfer_edit(new_quantity)
    change_quantity = new_quantity - self.quantity
    self.quantity = new_quantity
    
    update_stock(change_quantity, 'te')
  end
  
  def update_stock(change_quantity,adjust_type)
    ActiveRecord::Base.transaction do
      begin
        self.save
        
        #from store
        @stock = Stock.where(" store_id = ? and product_id = ? ", self.from_store_id, self.product_id).first
        if @stock.nil?
          @stock = Stock.new
          @stock.store_id = self.from_store_id
          @stock.product_id = self.product_id
        end
        
        @history = History.new(:adjust_type => adjust_type+'_f', :reference_id => self.id, :remark => self.remark)
        @stock.record_update(change_quantity * (-1), @history)
        
        #to store
        @stock = Stock.where(" store_id = ? and product_id = ? ", self.to_store_id, self.product_id).first
        if @stock.nil?
          @stock = Stock.new
          @stock.store_id = self.to_store_id
          @stock.product_id = self.product_id
        end
        
        @history = History.new(:adjust_type => adjust_type+'_t', :reference_id => self.id, :remark => self.remark)
        @stock.record_update(change_quantity, @history)
        
        true
      rescue
        false
      end
      
    end
    
      
  end
end
