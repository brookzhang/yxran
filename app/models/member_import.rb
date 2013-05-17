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
      member = Member.find_by_name(details.cell(i,1)) 
      if member.nil?
        member = Member.new
        
        member.name = details.cell(i,1)
        member.phone = details.cell(i,2)
        member.address = details.cell(i,3)
        member.remark = details.cell(i,4)
        member.level = details.cell(i,5)
        member.score = details.cell(i,6)
        member.user_id = user_id
        member.uuid = UUIDTools::UUID.random_create().to_s
        
        member.save!
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
        
      
      member = Member.find_by_name(details.cell(i,1)) 
      if member.nil?
        member = Member.new
        lookup = Lookup.get_one("member", details.cell(i,5).to_i.to_s)
        if lookup.nil? 
          errors.add(:base, "#{i}:E  level not exists#{details.cell(i,5)}.")
        end
        
        
        if !details.cell(i,5).to_i.is_a?(Integer)
          errors.add(:base, "#{i}:E  wrong level.")
        end
        if !details.cell(i,6).to_i.is_a?(Integer)
          errors.add(:base, "#{i}:F  wrong score.")
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
