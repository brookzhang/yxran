class StoreUser < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  
  attr_accessible :role, :store_id, :user_id
  
  
  validates_presence_of :store_id, :user_id, :role
  validates_inclusion_of :role, :in => Role.all.map(&:name), :message => 'must_be_system_role'
  validates_uniqueness_of :role, :scope => [:store_id, :user_id]
  
  validate :user_must_has_role
  
  validate do |store_user|
    user.errors.add 'base', 'user_has_not_this_role' if true # !User.find(user_id).has_role?(role)
  end
  
  def user_must_has_role
    errors.add :role, :user_has_not_this_role unless User.find(user_id).has_role?(role)
  end
  
  
  
  
end
