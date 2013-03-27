class Sale < ActiveRecord::Base
  has_many :histories
  has_many :sale_details
  
  belongs_to :store
  #belongs_to :member
  belongs_to :user
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :member_id , :remark, :category, :discount_type, :amount, :score,:used_score, :status, :user_id

  
  validates_presence_of :store_id
  #validates_uniqueness_of :name, :case_sensitive => false
  
  def my_sales(user_id)
    where(:user_id => user_id).order(" id desc ")
  end
  
  
  def create_sale(carts)
    begin
      self.transaction do
        #create sale record
        self.score = carts.sum {|c| c.score.nil? ? 0 : c.score }
        self.amount = carts.sum {|c| c.amount.nil? ? 0 : c.amount }
        self.used_score = 0  
        self.discount_type = 'D'
        self.used_score = 0
        self.status = 1
        
        self.save!
        
        
        #sale_details
        carts.each do |c|
          @sale_detail = SaleDetail.new(:sale_id => self.id,
                                        :product_id => c.product_id,
                                        :quantity => c.quantity,
                                        :unit_price => c.unit_price,
                                        :amount => c.amount,
                                        :discount => c.discount,
                                        :score => c.score,
                                        :status => 1
                                        )
          
          @sale_detail.save!
          @stock = Stock.fetch(c.store_id, c.product_id)
          @stock.quantity = 0 if @stock.quantity.nil?
          @stock.quantity += c.quantity * (-1)
          @stock.adjust_type = 'S'
          @stock.reference_id = self.id
          @stock.change_qty = c.quantity * (-1)
          @stock.change_remark = 'sale temp remark'
          @stock.save!
          
        end
        Cart.destroy(carts.map{|c| c.id })
        
        
        #member sale & record score
        if self.category == 'M' && self.discount_type == 'S' 
          @member = Member.find(self.member_id)
          @member.score += self.score
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
      false
    end
  end
  
  
  
end
