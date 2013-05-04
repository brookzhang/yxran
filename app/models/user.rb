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

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :store_id, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :account
  # attr_accessible :title, :body
  
  attr_accessor :login
  
  validates_presence_of :name, :account
  #validates_uniqueness_of :name, :email, :case_sensitive => false
  validates_uniqueness_of :name, :account, :case_sensitive => false
  
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(account) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
end
