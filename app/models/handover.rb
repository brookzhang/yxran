class Handover < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  
  after_create :user_take_over
  after_update :user_hand_over
  
  
  attr_accessible :store_id, :user_id, :status, :take_amount, :hand_amount,
                  :take_remark, :hand_remark, :took_at, :handed_at
  
  #validates_numericality_of :take_amount, :greater_than => 0
  #validates_numericality_of :hand_amount, :greater_than => 0
  
  private
  
  def user_take_over
    update_user_store_id self.store_id
  end
  def user_hand_over
    update_user_store_id nil
  end
  
  def update_user_store_id(store_id)
    
    @user = User.find(self.user_id)
    if @user.update_attribute(:store_id , store_id)
      return true
    else
      raise ActiveRecord::Rollback
      return false
    end
  end
  
end
