class OrderImport 
  
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  
  #:product_name, :quantity, :remark

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save(order)
    details = open_spreadsheet
    details.default_sheet = details.sheets.first
    
    (2..details.last_row).map do |i|
      if details.cell(i,2).to_i > 0
        product = Product.find_by_name(details.cell(i,1)) 
        order_detail = OrderDetail.new
        order_detail.order_id = order.id
        order_detail.product_id = product.id
        order_detail.quantity = details.cell(i,2)
        order_detail.remark = details.cell(i,3)
        order_detail.save!  
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
      (1..3).map do |col|
        if details.cell(i,col).nil? || details.cell(i,col) == '' 
          errors.add(:base, :content_is_nil)
        end
      end
      
      if !details.cell(i,2).to_i.is_a?(Integer)
        errors.add(:base, "#{i}:E  wrong quantiy.")
      end
      
      if details.cell(i,2).to_i > 0
        product = Product.find_by_name(details.cell(i,1))
        if product.nil?
          errors.add(:base, "#{i}:C  product not exists.")
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
