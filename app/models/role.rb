class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates_uniqueness_of :name, :case_sensitive => false
  
  scopify
end
