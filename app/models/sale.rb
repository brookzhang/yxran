class Sale < ActiveRecord::Base
  has_many :histories
  has_many :sale_details
  
  belongs_to :store
  #belongs_to :member
  belongs_to :user
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :member_id , :remark, :category, :discount_type, :quantity, :amount, :score,:used_score, :status, :user_id

  
  validates_presence_of :store_id
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  def create_sale(carts)
    begin
      ActiveRecord::Base.transaction do
        #create sale record
        #self.score = 0 #carts.sum {|c| c.score }
        self.amount = 0 #carts.sum {|c| c.amount }
        #self.used_score = 0 # carts.sum {|c| c.used_score }
        #self.discount_type = 'D'
        #self.quantity = 0
        #self.used_score = 0
        #self.status = 0
        
        self.save
        
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
          
          @sale_detail.save
          
          @stock = Stock.new(:store_id => self.store_id,
                             :product_id => c.product_id,
                             :adjust_type => 'S',
                             :reference_id => self.id,
                             :change_qty => @sale_detail.quantity * (-1)
                             :change_remark => 'sale temp remark'
                             )
          @stock.save_change
          
          
        end 
      end
    rescue
      false
    end
  end
  
  
  
  def create_sale1(carts)
    
    
    ActiveRecord::Base.transaction do
      begin
        #create sale record
        self.score = 0 #carts.sum {|c| c.score }
        self.amount = 0 #carts.sum {|c| c.amount }
        #self.used_score = carts.sum {|c| c.used_score }
        self.save
      
          #member sale & record score
          if self.category == 'M' && self.discount_type == 'S' 
            @member = Member.find(self.member_id)
            @member.score += self.score
            @member.save
          end
          
          
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
          
          @stock = Stock.where(" store_id = ? and product_id = ? ", self.store_id, @sale_detail.product_id).first
          if @stock.nil?
            @stock = Stock.new
            @stock.store_id = self.store_id
            @stock.product_id = self.product_id
          end
          @history = History.new(:adjust_type => 'S',
                                 :reference_id => self.id,
                                 :remark => self.remark
                                 )
          @stock.record_update(self.quantity * (-1), @history)
        end 
        
        
        
        true
        
      rescue
        false
      end
    end
  end
  
  
end
