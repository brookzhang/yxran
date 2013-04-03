class Handover < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  
  
  
  attr_accessible :store_id, :user_id, :status, :take_amount, :hand_amount,
                  :take_remark, :hand_remark, :took_at, :handed_at
  
  
end
