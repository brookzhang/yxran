class Store < ActiveRecord::Base
  has_many :stocks
  has_many :sales
  has_many :users
  has_many :orders
  has_many :transfers
  has_many :handovers
  has_many :expenses
  has_many :balances
  has_many :store_users
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :category, :balance, :remark , :status

  
  validates_presence_of :name , :balance
  validates_uniqueness_of :name, :case_sensitive => false
  validates_numericality_of :balance
  
  
  scope :authorized_stores, lambda{ |user_id, role| joins(:store_users).where(:store_users => { :user_id => user_id, :role => role })}
  
end
