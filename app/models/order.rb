class Order < ActiveRecord::Base
  
  belongs_to :store
  belongs_to :user
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id , :remark, :status, :user_id

  
  validates_presence_of :store_id 
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  
  def order_add()
    
    update_stock(self.quantity, 'o')
  end
  
  
  
  def order_edit(new_quantity)
    change_quantity = new_quantity - self.quantity
    self.quantity = new_quantity
    
    update_stock(change_quantity, 'oe')
  end
  
  def update_stock(change_quantity,adjust_type)
    ActiveRecord::Base.transaction do
      begin
        self.save
        @stock = Stock.where(" store_id = ? and product_id = ? ", self.store_id, self.product_id).first
        if @stock.nil?
          @stock = Stock.new
          @stock.store_id = self.store_id
          @stock.product_id = self.product_id
        end
        
        @history = History.new(:adjust_type => adjust_type, :reference_id => self.id, :remark => self.remark)
        @stock.record_update(change_quantity, @history)
        true
      rescue
        false
      end
      
    end
    
      
  end
  
end
