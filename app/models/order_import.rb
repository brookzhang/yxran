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
      if details.cell(i,1).present?
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
    end
    errors.blank?
  end
  
  def valid?
    details = open_spreadsheet
    details.default_sheet = details.sheets.first
    
    (2..details.last_row).map do |i|
      if details.cell(i,1).present?
        errors.add(:base, I18n.t(:please_input_product_on_line_n, :line => i)) if details.cell(i,1).blank?
        errors.add(:base, I18n.t(:please_input_quantity_on_line_n, :line => i)) if details.cell(i,2).blank?
        errors.add(:base, I18n.t(:wrong_quantity_on_line_n, :line => i)) if !details.cell(i,2).is_a?(Numeric)

        if errors.blank?
          errors.add(:base, I18n.t(:wrong_product_on_line_n, :line => i)) if Product.find_by_name(details.cell(i,1)).nil?
        end
      end
    end
    
    errors.blank?
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
