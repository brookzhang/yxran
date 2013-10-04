class AddUnitPriceToOrderDetail < ActiveRecord::Migration
  def change
  	add_column :order_details, :unit_price, :float
  end
end
