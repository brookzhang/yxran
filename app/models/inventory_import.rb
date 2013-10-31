class InventoryImport 
  
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

  def save(inventory)
    details = open_spreadsheet
    details.default_sheet = details.sheets.first
    
    (2..details.last_row).map do |i|
      if details.cell(i,1).present?
        check_quantity = details.cell(i,2).present? ? details.cell(i,2).to_i : 0
        
          product = Product.find_by_name(details.cell(i,1)) 
          inventory_detail = InventoryDetail.new
          inventory_detail.inventory_id = inventory.id
          inventory_detail.product_id = product.id
          
          inventory_detail.stock_quantity = Stock.get_quantity(inventory.store_id, product.id)
          inventory_detail.check_quantity = check_quantity
          inventory_detail.change_quantity = inventory_detail.stock_quantity - inventory_detail.check_quantity
          inventory_detail.unit_price = product.unit_price(inventory.store_id)
          inventory_detail.amount = inventory_detail.unit_price * inventory_detail.change_quantity
          inventory_detail.save! if inventory_detail.change_quantity != 0 
        
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
