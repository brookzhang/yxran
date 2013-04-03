class Expense < ActiveRecord::Base
  belongs_to :store
  
  attr_accessible :amount, :category, :remark, :store_id, :user_id
  
  validates_numericality_of :amount, :greater_than => 0
  
  
  after_save :update_store_balance
  
  
  
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
