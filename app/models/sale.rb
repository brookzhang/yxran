class Sale < ActiveRecord::Base
  has_many :histories
  has_many :sale_details
  
  belongs_to :store
  belongs_to :member
  belongs_to :user
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :user_id, :member_id , :category, :amount, :actual_amount, :score,:used_score, :remark, :status
  #status : 1-recorded 9-cancel
  #category : sale type M-member buy, R-retail sale, C-cost sale
  
  
  attr_accessor :check_message

  
  validates_presence_of :store_id, :actual_amount
  #validates_uniqueness_of :name, :case_sensitive => false
  
  validates_numericality_of :actual_amount, :greater_than_or_equal_to => 0
  validates_numericality_of :amount 
  
  def my_sales(user_id)
    where(:user_id => user_id).order(" id desc ")
  end
  
  
  def create_sale(carts)
    if !check_sale
      return false
    end
    
    begin
      self.transaction do
        #create sale record
        if self.category == 'C'
          self.actual_amount = 0
        end
        
        self.amount = carts.sum {|c| c.amount.nil? ? 0 : c.amount }
        self.status = 1
        self.save!
        
        
        @store = Store.find(self.store_id)
        @store.balance += self.actual_amount
        @store.save!
        
        #:adjusted_by, :adjusted_to, :category, :reference_id, :store_id, :user_id
        @balance = Balance.new
        @balance.adjusted_by = self.actual_amount
        @balance.adjusted_to = @store.balance
        @balance.category = 'S'
        @balance.reference_id = self.id
        @balance.store_id = self.store_id
        @balance.user_id = self.user_id
        @balance.save!
        
        #sale_details
        carts.each do |c|
          @sale_detail = SaleDetail.new(:sale_id => self.id,
                                        :product_id => c.product_id,
                                        :quantity => c.quantity,
                                        :unit_price => c.unit_price,
                                        :amount => c.amount,
                                        :status => 1
                                        )
          
          @sale_detail.save!
          @stock = Stock.fetch(self.store_id, c.product_id)
          @stock.quantity = 0 if @stock.quantity.nil?
          @stock.quantity += c.quantity * (-1)
          @stock.adjust_category = 'S'
          @stock.reference_id = self.id
          @stock.change_qty = c.quantity * (-1)
          #@stock.change_remark = self.remark
          @stock.save!
          
        end
        Cart.destroy(carts.map{|c| c.id })
        
        
        #member sale & record score
        self.score ||= 0
        self.used_score ||= 0
        if self.category == 'M' && (self.score > 0  || self.used_score > 0 )
          @member = Member.find(self.member_id)
          @member.score -= self.used_score if self.used_score > 0
          @member.score += self.score if self.score > 0
          @member.all_score += self.score if self.score > 0
          @member.save!
        end
        
      end
      true
    rescue => err
      logger.error "****************************"  
      logger.error "#{err.message}"  
      logger.error "#{err.backtrace.join('\n')}"  
      logger.error "****************************"  
      logger.debug "======= error output: " + err.to_s 
      self.check_message = 'unable_to_create'
      false
    end
  end
  
  
  #*************************
  # for user on duty, could cancel sale
  #*************************
  def cancel
    if !is_on_duty?
      return false
    end
    
    if !is_ok_to_cancel?
      return false
    end
    
    
    begin
      self.transaction do
        #create sale record
        self.status = 9
        self.save!
        
        @store = Store.find(self.store_id)
        @store.balance -= self.actual_amount
        @store.save!
        
        @balance = Balance.new
        @balance.adjusted_by = self.actual_amount * (-1)
        @balance.adjusted_to = @store.balance
        @balance.category = 'S'
        @balance.reference_id = self.id
        @balance.store_id = self.store_id
        @balance.user_id = self.user_id
        @balance.save!
        
        @sale_details = SaleDetail.where(:sale_id => self.id) 
        @sale_details.each do |s|
          s.status = 9
          s.save!
          @stock = Stock.fetch(self.store_id, s.product_id)
          @stock.quantity += s.quantity 
          @stock.adjust_category = 'S'
          @stock.reference_id = self.id
          @stock.change_qty = s.quantity 
          @stock.change_remark = "sale canceled"
          @stock.save!
          
        end
        
        #member sale & record score
        if self.category == 'M' && (self.score > 0 || self.used_score > 0)
          @member = Member.find(self.member_id)
          @member.score += self.used_score if self.used_score > 0
          @member.score -= self.score if self.score > 0 
          @member.all_score -= self.score if self.score > 0 
          @member.save!
        end
        
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
  
  
  private
  
  
  def check_sale()
    self.check_message = 'pass' 
    if self.category != 'M'
      #maybe need check stock
      #return true
    end
    
    if self.category == 'M'
      
      if self.member_id.nil?
        self.check_message = 'please_select_member'
      else
        @member = Member.find(self.member_id)
        self.check_message = 'not_enough_score_to_use' if self.used_score > @member.score
      end
    end
      
    self.check_message == 'pass' 
    
  end
  
  
  
  
  
  
  
  def is_ok_to_cancel?
    self.check_message = 'pass'
    
    if self.category == 'M'
      self.check_message = 'member_has_not_enough_score' if (self.member.score.nil? ? 0 : self.member.score) - (self.score.nil? ? 0 : self.score) + (self.used_score.nil? ? 0 : self.used_score) < 0
    end
    
    self.check_message = 'not_enough_balance_to_cancel' if self.store.balance < self.actual_amount 
    
    self.check_message == 'pass'     
    
  end
  
  
end
