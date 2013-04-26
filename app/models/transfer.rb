class Transfer < ActiveRecord::Base
  belongs_to :from_store, :class_name => 'Store'
  belongs_to :to_store, :class_name => 'Store'
  belongs_to :product
  belongs_to :transferer, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  has_many :transfer_details

  # Setup accessible (or protected) attributes for your model
  attr_accessible :from_store_id, :to_store_id, :transfer_remark, :receive_remark, :transferer_id  ,:receiver_id

  
  validates_presence_of :from_store_id, :to_store_id 
  #validates_uniqueness_of :name, :case_sensitive => false
  
  def amount_sum
    @details = self.transfer_details
    @details.size == 0 ? 0 : @details.sum{|d| d.amount }
  end
  
   
end
