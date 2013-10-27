class InventoryDetail < ActiveRecord::Base
  attr_accessible :inventory_id, :product_id #, :stock_quantity, :check_quantity, :change_quantity, :unit_price, :amount, :status

  belongs_to :inventory 
  belongs_to :product

  
  validates_presence_of :inventory_id, :product_id

  
end
