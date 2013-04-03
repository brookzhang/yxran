class Handover < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  
  after_save :update_user_store_id
  
  attr_accessible :store_id, :user_id, :status, :take_amount, :hand_amount,
                  :take_remark, :hand_remark, :took_at, :handed_at
  
  
  
  private
  
  def update_user_store_id
    @user = User.find(self.user_id)
    @user.update_attribute(:store_id , self.store_id)
  end
  
end
