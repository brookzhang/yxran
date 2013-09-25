class Lookup < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :code, :category, :description, :sequence, :status

  
  validates_presence_of :code, :category, :description
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  def self.get_one(category,code)
    where(:category => category, :code => code).first
  end
  def self.get_one_by_description(category,description)
    where(:category => category, :description => description).first
  end
  
  def self.list(category)
    where(:category => category)
  end

  def self.l(code, category)
    lookup = Lookup.where(" code = ? and category = ? ", code.to_s, category).first
    lookup.nil? ? code : lookup.description
  end
end
