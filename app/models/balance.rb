class Balance < ActiveRecord::Base
  attr_accessible :amount, :category, :reference_id, :store_id, :user_id
end
