class Balance < ActiveRecord::Base
  attr_accessible :adjusted_by, :adjusted_to, :category, :reference_id, :store_id, :user_id
  
end
