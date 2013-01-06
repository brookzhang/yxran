class Sale < ActiveRecord::Base
  has_many :histories
  
  belongs_to :store
  belongs_to :product
  belongs_to :member
  belongs_to :user
  
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :store_id, :product_id, :member_id , :remark, :category, :quantity,:unit_price, :amount, :score,:used_score, :status, :user_id

  
  validates_presence_of :store_id, :product_id, :quantity
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  def sale_add()
    ActiveRecord::Base.transaction do
      begin
        if self.category == 'M'
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
