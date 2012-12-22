class Event < ActiveRecord::Base
  belongs_to :users

  # Setup accessible (or protected) attributes for your model
  attr_accessible :category, :content, :user_id, :created_at

  
  validates_presence_of :category, :content, :user_id
  #validates_uniqueness_of :name, :case_sensitive => false
end
