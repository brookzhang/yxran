class Sale < ActiveRecord::Base
  has_many :histories
  has_many :sale_details
  
  belongs_to :store
  #belongs_to :member
  belongs_to :user
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :user_id, :member_id , :category, :amount, :actual_amount, :score,:used_score, :remark, :status
  
  attr_accessor :check_message

  
  validates_presence_of :store_id, :actual_amount
  #validates_uniqueness_of :name, :case_sensitive => false
  
  validates_numericality_of :actual_amount, :greater_than => 0
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
        self.amount = carts.sum {|c| c.amount.nil? ? 0 : c.amount }
        #self.used_score = 0
        self.status = 1
        self.save!
        
        @store = Store.find(self.store_id)
        @store.balance += self.actual_amount
        @store.save
        
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
          @stock = Stock.fetch(c.store_id, c.product_id)
          @stock.quantity = 0 if @stock.quantity.nil?
          @stock.quantity += c.quantity * (-1)
          @stock.adjust_type = 'S'
          @stock.reference_id = self.id
          @stock.change_qty = c.quantity * (-1)
          #@stock.change_remark = self.remark
          @stock.save!
          
        end
        Cart.destroy(carts.map{|c| c.id })
        
        
        #member sale & record score
        if self.category == 'M' && (self.score > 0 || self.used_score > 0)
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
      #logger.error "#{err.backtrace.join('\n')}"  
      logger.error "****************************"  
      #logger.debug "======= error output: " + err.to_s 
      self.check_message = 'unable_to_create'
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
      
    if self.check_message == 'pass' 
      true
    else
      false
    end
    
  end
  
  
end
