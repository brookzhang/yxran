class Member < ActiveRecord::Base
  #has_many :sales
  belongs_to :user
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :phone, :address, :remark, :level, :score, :user_id

  
  validates_presence_of :name, :phone
  #validates_uniqueness_of :phone, :case_sensitive => false
  
  
  scope :by_name, lambda{ |name| where(" name like ? ", '%' + name + '%') if !(name.nil? && name == '' )}
  scope :by_phone, lambda{ |phone| where(" phone = ? ", phone) if !phone.nil? && phone != '' }
  
  
  
end
