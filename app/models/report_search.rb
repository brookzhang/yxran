class ReportSearch
  
  attr_accessor :by_date_period, :by_store, :by_product, :by_category, :category_for
  
  attr_accessor :store_id, :product_name, :date_period, :category
  
  
  
  def new(*args)
    
  end
  
  
  
  def date_range
    date_range_from_date_period = case self.date_period.to_s
      when '1' then (DateTime.now.beginning_of_day..DateTime.now.end_of_day )
      when '2' then (DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day )
      when '3' then (DateTime.now.beginning_of_week..DateTime.now.end_of_day )
      when '4' then (DateTime.now.prev_week.beginning_of_week..DateTime.now.prev_week.end_of_week )
      when '5' then (DateTime.now.beginning_of_month..DateTime.now.end_of_day )
      when '6' then (DateTime.now.prev_month.beginning_of_month..DateTime.now.prev_month.end_of_month )
      else (DateTime.now.beginning_of_day..DateTime.now.end_of_day )
    end
      
    date_range_from_date_period
  end
  
  
end
