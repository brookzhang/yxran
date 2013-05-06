class Balance < ActiveRecord::Base
  attr_accessible :adjust_by, :adjust_to, :category, :reference_id, :store_id, :user_id
  
end
