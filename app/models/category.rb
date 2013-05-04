class Category < ActiveRecord::Base
  has_many :products
  has_many :discounts
  has_many :categories
  
  belongs_to :parent, :class_name => 'Category'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :parent_id, :name, :description, :sequence, :status

  
  validates_presence_of :parent_id, :name, :description
  #validates_uniqueness_of :name, :case_sensitive => false
  
  
  def self.has_children(category_id)
    !Category.where( :parent_id => category_id ).first.nil?
  end
  def self.has_children(category_ids)
    !Category.where( :parent_id => category_ids ).first.nil?
  end
  
  
  def self.sub_id_array(category_id)
    @id_array = []
    @id_array << where(:parent_id => category_id ).map{|c| c.id}
    @id_array.map do |c|
      @id_array << sub_id_array(c) if has_children(c)
    end
    @id_array
  end
  
  
  
  def parent
    self.parent_id.nil? || self.parent_id==0 ? Category.new(:name => 'root_category') : Category.find(self.parent_id)
  end
  
  def parents
    
    
  end
  
  def has_children
    !Category.where( :parent_id => self.id ).first.nil?
  end
  
  def has_product
    !Product.where( :category_id => self.id ).first.nil?
  end
  
  def hole_name
    
  end
  
  
  
  def self.find_by_name(name)
    where(:name => name).first
  end
  
  
end
