class ProductImport 
  
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  
  #:product_name, :product_description, :category, :sub_category, :measurement, :unit_price

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  #only import products which not exists
  def import
    details = open_spreadsheet
    details.default_sheet = details.sheets.first
    
    (2..details.last_row).map do |i|
      product = Product.find_by_name(details.cell(i,1)) 
      if product.nil?
        product = Product.new
        category = Category.find_by_name(details.cell(i,3))
        sub_category = Category.find_by_name(details.cell(i,4))
        if category.nil? || sub_category.nil?
          errors.add(:base, "category not exists.")
        end
        
        product.name = details.cell(i,1)
        product.description = details.cell(i,2)
        product.category_id = sub_category.id
        product.measurement = details.cell(i,5)
        product.unit_price = details.cell(i,6)
        product.save!
      end
      
    end
    
    if errors.any?
      false
    else
      true
    end
    
    
  end
  
  def valid?
    details = open_spreadsheet
    details.default_sheet = details.sheets.first
    
    (2..details.last_row).map do |i|
      (1..6).map do |col|
        if details.cell(i,col).nil? || details.cell(i,col) == '' 
          errors.add(:base, :wrong_format)
        end
      end
        
      
      product = Product.find_by_name(details.cell(i,1)) 
      if product.nil?
        product = Product.new
        category = Category.find_by_name(details.cell(i,3))
        sub_category = Category.find_by_name(details.cell(i,4))
        if category.nil? 
          errors.add(:base, "#{i}:C  category not exists.")
        end
        if sub_category.nil?
          errors.add(:base, "#{i}:D  category not exists.")
        end
        
      end 
      
      
    end
    
    if errors.any?
      false
    else
      true
    end
  end
  

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
end
