class Order < ActiveRecord::Base
  has_many :histories
  
  belongs_to :product
  belongs_to :store
  belongs_to :user
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :product_id , :quantity, :amount, :remark, :status, :user_id

  
  validates_presence_of :store_id, :product_id , :quantity, :amount 
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  def order_add()
    if self.save
      change_stock(self.store_id, self.product_id, self.quantity, self.id, "order_add")
    else
      false
    end   
  end
  
  def order_edit(order_array)
    change_quantity = order_array[:quantity].to_i - self.quantity
    Stock.change_stock(self.store_id, self.product_id, change_quantity, self.id, "order_edit")
    
    self.update_attributes(order_array)

    
  end
  
end
