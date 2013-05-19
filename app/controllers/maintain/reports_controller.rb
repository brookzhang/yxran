class Maintain::ReportsController < Maintain::ApplicationController
  before_filter :get_sale_search, :only => [:sale_details_report,
                                            :sale_products_report,
                                            :sale_amount_by_store_report,
                                            :sale_amount_by_user_report
                                            ]
  
  def index
  end
  
  def sale_details_report
    @sales = Sale.find(:all,
                       :select => " sales.*, sale_details.*, products.measurement, products.name as product_name, stores.name as store_name, lookups.description as category_name, users.name as user_name",
                       :from => " sales inner join sale_details on sales.id=sale_details.sale_id
                        inner join products on sale_details.product_id = products.id
                        inner join stores on sales.store_id = stores.id
                        inner join lookups on sales.category = lookups.code and lookups.category = 'sale_category'
                        inner join users on sales.user_id = users.id ",
                       :conditions => @conditions,
                       :order => " sale_details.id desc "
                       ) unless @conditions.size == 0
  end
  
  
  
  
  def sale_products_report
    @sales = Sale.find(:all,
                       :select => " sale_details.product_id, products.measurement, products.name as product_name, sum(sale_details.quantity) as quantity",
                       :from => " sales inner join sale_details on sales.id=sale_details.sale_id
                        inner join products on sale_details.product_id = products.id ",
                       :conditions => @conditions,
                       :group => " sale_details.product_id, products.measurement, products.name ",
                       :order => " quantity desc "
                       ) unless @conditions.size == 0
    
    
  end
  
  
  
  def sale_amount_by_store_report
    @sales = Sale.find(:all,
                       :select => " stores.name store_name, sum(sales.actual_amount) as actual_amount",
                       :from => " sales inner join stores on sales.store_id = stores.id",
                       :conditions => @conditions,
                       :group => " stores.name ",
                       :order => " actual_amount desc "
                       ) unless @conditions.size == 0
    
  end
  
  def sale_amount_by_user_report
    @sales = Sale.find(:all,
                       :select => " users.name as user_name, sum(sales.actual_amount) as actual_amount",
                       :from => " sales inner join users on sales.user_id=users.id",
                       :conditions => @conditions,
                       :group => " users.name ",
                       :order => " actual_amount desc "
                       ) unless @conditions.size == 0
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def get_sale_search
    @stores = Store.all.map{|s| [s.name, s.id]}.insert(0, [t(:all_stores),0])
    @categories = Lookup.where(:category => 'sale_category').map{|c| [c.description, c.code]}.insert(0, [t(:all_categories),'all'])
    @date_periods = [[t(:today), 1],
                     [t(:yesterday),2],
                     [t(:this_week), 3],
                     [t(:last_week), 4],
                     [t(:this_month), 5],
                     [t(:last_month), 6]
                    ]
    @sale_report = SaleReport.new
    @sale_report.date_period = params[:date_period] || 1
    @sale_report.store_id = params[:store_id] || 0
    @sale_report.category = params[:category] || 'all'
    @sale_report.product_name = params[:product_name] || ''
    
    @date_range = case @sale_report.date_period.to_s
      when '1' then (DateTime.now.beginning_of_day..DateTime.now.end_of_day )
      when '2' then (DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day )
      when '3' then (DateTime.now.beginning_of_week..DateTime.now.end_of_day )
      when '4' then (DateTime.now.prev_week.beginning_of_week..DateTime.now.prev_week.end_of_week )
      when '5' then (DateTime.now.beginning_of_month..DateTime.now.end_of_day )
      when '6' then (DateTime.now.prev_month.beginning_of_month..DateTime.now.prev_month.end_of_month )
      else (DateTime.now.beginning_of_day..DateTime.now.end_of_day )
      end
      
    @conditions = {}
    @conditions[:sales] = {}
    @conditions[:sales][:created_at] = @date_range 
    @conditions[:sales][:store_id] = @sale_report.store_id if @sale_report.store_id.to_i > 0
    @conditions[:sales][:category] = @sale_report.category if @sale_report.category != 'all'
    
    @conditions[:products] = {}
    @conditions[:products][:name] = @sale_report.product_name if !@sale_report.product_name.empty?
    
  end
  
end
