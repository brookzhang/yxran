class ProductPrice < ActiveRecord::Base
  
  belongs_to :store
  belongs_to :product
  attr_accessible :store_id, :product_id, :unit_price
end
