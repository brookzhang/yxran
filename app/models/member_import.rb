class MemberImport 
  
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file
  
  #:name, :phone, :address, :remark, :level, :score

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  #only import members which not exists
  def import(user_id)
    details = open_spreadsheet
    details.default_sheet = details.sheets.first
    
    (2..details.last_row).map do |i|
      if details.cell(i,1).present?
        member = Member.where(:name => details.cell(i,1), :phone => details.cell(i,2)).first 
        if member.nil? 
          member = Member.new(:name => details.cell(i,1), :phone => details.cell(i,2))
        end
        member.address = details.cell(i,3) if details.cell(i,3).present?
        member.remark = details.cell(i,4) if details.cell(i,4).present?
        member.level = details.cell(i,5) if details.cell(i,5).present?
        member.level ||= 0 
        member.score = details.cell(i,6) if details.cell(i,6).present?
        member.score ||= 0 
        member.start_date = details.cell(i,7) if details.cell(i,7).present?
        member.all_score = member.score 
        member.user_id = user_id
        member.uuid = UUIDTools::UUID.random_create().to_s
        member.save
      end
      
    end
    
    errors.empty?
  end



  
  def valid?
    details = open_spreadsheet
    details.default_sheet = details.sheets.first
    
    (2..details.last_row).map do |i|
      errors.add(:base, I18n.t(:please_input_name_on_line_n, :line => i)) if details.cell(i,1).blank?
      errors.add(:base, I18n.t(:please_input_phone_on_line_n, :line => i)) if details.cell(i,2).blank?
      errors.add(:base, I18n.t(:please_input_right_level_on_line_n, :line => i)) if details.cell(i,5).present? && ![0,1,9].include?(details.cell(i,5))
      errors.add(:base, I18n.t(:please_input_score_on_line_n, :line => i)) if details.cell(i,6).blank?
      errors.add(:base, I18n.t(:please_input_right_score_on_line_n, :line => i)) if details.cell(i,6).present? && !details.cell(i,6).is_a?(Float)
      errors.add(:base, I18n.t(:please_input_right_date_on_line_n, :line => i)) if details.cell(i,7).present? && !details.cell(i,7).is_a?(Date)
      puts "==========="
      puts details.cell(i,7)
      puts "==#{(Integer.parse(details.cell(i,6)) rescue nil).nil?}==" 
      puts "==#{ details.cell(i,6).class}==" 
      puts "==========="
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
