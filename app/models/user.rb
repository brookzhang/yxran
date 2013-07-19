
class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  
  belongs_to :store
  
  has_many :members
  has_many :sales
  has_many :transfers
  has_many :orders
  has_many :histories
  has_many :members
  has_many :events
  has_many :handovers
  has_many :expenses
  has_many :balances
  has_many :store_users

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :account, :store_id, :role
  # attr_accessible :title, :body
  
  attr_accessor :login, :role
  
  
  validates_presence_of :email, :account, :role
  #validates_uniqueness_of :name, :email, :case_sensitive => false
  validates_uniqueness_of :email, :account, :case_sensitive => false
  
  
  scope :by_category_name, lambda { |name| where("category_id in (select id from categories where name = ? )", name) unless name.nil? || name == '' }
  scope :employees, where(" id not in (select user_id from users_roles where role_id in (select id from roles where name in ('admin','manager'))) ")
  
  
  after_save :set_role
  
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(account) = :value OR lower(email) = :value and status = 1 ", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  def is_owned_by?(agent)
    self.id == agent.id
    # or, if you can safely assume the agent is always a User, you can 
    # avoid the additional user query:
    # self.owner_id == agent.id
  end
  
  def set_role
    unless self.role.blank?
      logger.error "---------start-----------"
      self.remove_all_roles
      logger.error "removed all roles"
      self.role.split(',').each do |r|
        self.add_role r
      end
      logger.error "----------end----------"
    end
    
  end
  
  def list_roles
    roles = ''
    if self.roles.count > 0
      roles = self.roles.map{|r| Lookup.get_one('role_category',r.name).description }.join(",")
    end
    roles
  end
  
  def remove_all_roles
    self.roles.each do |role|
      self.remove_role role.name
    end
  end
  
end
