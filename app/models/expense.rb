class Expense < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  
  attr_accessible :amount, :category, :remark, :store_id, :user_id, :status
  # status 1-active  9-cancel
  
  attr_accessor :check_message
  
  validates_numericality_of :amount, :greater_than_or_equal_to => 0
  validates_presence_of :category, :amount, :store_id, :user_id, :remark
  
  #after_save :update_store_balance
  
  

  def number
    Lookup.l(self.category,"expense_category") + '#'+ ("%05d" % self.id)
  end
  
  
  def create_balance
    begin
      self.transaction do
        self.save!
        
        @store = Store.find(self.store_id)
        @store.balance -= self.amount
        @store.save!
        
        #:adjusted_by, :adjusted_to, :category, :reference_id, :store_id, :user_id
        @balance = Balance.new
        @balance.adjusted_by = self.amount
        @balance.adjusted_to = @store.balance
        @balance.category = 'E'
        @balance.reference_id = self.id
        @balance.store_id = self.store_id
        @balance.user_id = self.user_id
        @balance.save!
        
        
      end
      true
    rescue => err
      errors.add :remark, :unable_to_create
      logger.error "****************************"  
      logger.error "#{err.message}"  
      #logger.error "#{err.backtrace.join('\n')}"  
      logger.error "****************************"  
      #logger.debug "======= error output: " + err.to_s 
      self.check_message = 'unable_to_create'
      false
    end
  end
  
  
  
  #*************************
  # for user on duty, could cancel expense
  #*************************
  def cancel
    if !is_on_duty?
      return false
    end
    
    begin
      self.transaction do
        #create sale record
        self.status = 9
        self.save!
        
        @store = Store.find(self.store_id)
        @store.balance += self.amount
        @store.save!
        
        @balance = Balance.new
        @balance.adjusted_by = self.amount
        @balance.adjusted_to = @store.balance
        @balance.category = 'E'
        @balance.reference_id = self.id
        @balance.store_id = self.store_id
        @balance.user_id = self.user_id
        @balance.save!
        
      end
      true
    rescue => err
      logger.error "****************************"  
      logger.error "#{err.message}"  
      #logger.error "#{err.backtrace.join('\n')}"  
      logger.error "****************************"  
      #logger.debug "======= error output: " + err.to_s 
      self.check_message = 'unable_to_cancel'
      false
    end
  end
  
  
  
  
  def is_owned_by?(agent)
    self.user == agent
    # or, if you can safely assume the agent is always a User, you can 
    # avoid the additional user query:
    # self.owner_id == agent.id
  end
  
  
  def is_on_duty?
    @handover = Handover.where(:user_id => self.user_id,
                               :store_id => self.store_id,
                               :status => 0
                               ).order("id desc").first
    if self.user.store_id.nil? || @handover.nil? 
      false
    elsif @handover.took_at <= self.created_at
      true
    else
      false
    end
  end
  
  
  
  
  
end
