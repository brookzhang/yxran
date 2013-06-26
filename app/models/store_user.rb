class StoreUser < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  
  attr_accessible :role, :store_id, :user_id
  
  
  
end
