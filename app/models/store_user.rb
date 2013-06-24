class StoreUser < ActiveRecord::Base
  attr_accessible :role, :store_id, :user_id
end
