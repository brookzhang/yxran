class Member < ActiveRecord::Base
  #set_primary_key "uuid"
  
  #include UUIDHelper
  has_many :sales
  belongs_to :user

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :phone, :address, :remark, :level, :score, :user_id, :uuid, :start_date
  
  
  validates_presence_of :name, :phone, :level, :uuid, :start_date
  validates_uniqueness_of :name, :scope => :phone, :case_sensitive => false
  #validates_uniqueness_of :uuid, :case_sensitive => false
  
  
  scope :by_name, lambda{ |name| where(" name like ? ", '%' + name + '%') unless (name.nil? || name.empty?) }
  scope :by_phone, lambda{ |phone| where(" phone = ? ", phone) unless (phone.nil? || phone.empty?) }
  
  
  def is_ok_to_destroy?
    self.score == 0 && !Sale.exists?(:member_id => self.id) 
  end
  
  
  
  
  def is_owned_by?(agent)
    self.user_id == agent.id
    # or, if you can safely assume the agent is always a User, you can 
    # avoid the additional user query:
    # self.owner_id == agent.id
  end
  
  
  
  def self.find_by_name(name)
    where(:name => name).first
  end
  
  
end
