class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  
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
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :store_id
  # attr_accessible :title, :body
  
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  
  
end
