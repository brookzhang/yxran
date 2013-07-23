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
      if details.cell(i,1).present?
        product = Product.find_by_name(details.cell(i,1)) 
        if product.nil?
          product = Product.new
          product.name = details.cell(i,1)
          product.description = details.cell(i,2)
          product.category_id = Category.find_by_name(details.cell(i,4)).id
          product.measurement_id = Measurement.find_by_name(details.cell(i,5)).id
          product.default_price = details.cell(i,6)
          product.save
        end
      end
    end
    errors.empty?
  end
  



  def valid?
    details = open_spreadsheet
    details.default_sheet = details.sheets.first
    
    (2..details.last_row).map do |i|
      if details.cell(i,1).present?
        errors.add(:base, I18n.t(:please_input_category_on_line_n, :line => i)) if details.cell(i,3).blank?
        errors.add(:base, I18n.t(:please_input_subcategory_on_line_n, :line => i)) if details.cell(i,4).blank?
        errors.add(:base, I18n.t(:please_input_measurement_on_line_n, :line => i)) if details.cell(i,5).blank?
        errors.add(:base, I18n.t(:please_input_unit_price_on_line_n, :line => i)) if details.cell(i,6).blank?

        if errors.empty?
          errors.add(:base, I18n.t(:wrong_category_on_line_n, :line => i)) if Category.find_by_name(details.cell(i,3)).nil?
          errors.add(:base, I18n.t(:wrong_subcategory_on_line_n, :line => i)) if Category.find_by_name(details.cell(i,4)).nil?
          errors.add(:base, I18n.t(:wrong_measurement_on_line_n, :line => i)) if Measurement.find_by_name(details.cell(i,5)).nil?
          errors.add(:base, I18n.t(:wrong_unit_price_format_on_line_n, :line => i)) if !details.cell(i,6).is_a?(Numeric)
        end
      end
    end
    errors.empty?
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
