class Sale < ActiveRecord::Base
  has_many :histories
  
  belongs_to :store
  belongs_to :member
  belongs_to :user
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :member_id , :remark, :category, :discount_type, :quantity, :amount, :score,:used_score, :status, :user_id

  
  validates_presence_of :store_id, :quantity
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  def create(carts, member)
    
    
    ActiveRecord::Base.transaction do
      begin
        #create sale record
        self.store_id = carts.first.store_id
        self.user_id = carts.first.user_id
        self.member_id = @member.nil? || self.category != 'M' ? nil : @member.id
        self.score = carts.each {|c| c.score }.compact.reduce(:+)
        self.amount = carts.each {|c| c.amount }.compact.reduce(:+)
        self.used_score = carts.each {|c| c.used_score }.compact.reduce(:+)
      
        #member sale & record score
        if self.category == 'M' && self.discount_type == 'S' 
          self.score = self.amount / 10 
          @member = Member.find(self.member_id)
          @member.score += self.score
          @member.save
        end
        
        self.save
        
        @stock = Stock.where(" store_id = ? and product_id = ? ", self.store_id, self.product_id).first
        if @stock.nil?
          @stock = Stock.new
          @stock.store_id = self.store_id
          @stock.product_id = self.product_id
        end
        @history = History.new(:adjust_type => 's', :reference_id => self.id, :remark => self.remark)
        @stock.record_update(self.quantity * (-1), @history)
        
        true
        
      rescue
        false
      end
    end
  end
  
  
  
  
end
