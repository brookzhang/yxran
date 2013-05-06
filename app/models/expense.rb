class Expense < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  
  attr_accessible :amount, :category, :remark, :store_id, :user_id, :status
  
  validates_numericality_of :amount, :greater_than => 0
  
  
  after_save :update_store_balance
  
  
  def is_owned_by?(agent)
    self.user == agent
    # or, if you can safely assume the agent is always a User, you can 
    # avoid the additional user query:
    # self.owner_id == agent.id
  end
  
  
  private
  
  def update_store_balance
    @store = Store.find(self.store_id)
    @store.balance -= self.amount
    #@store.balance = nil
    if @store.save
      return true
    else
      raise ActiveRecord::Rollback
      return false
    end
  end
  
end
