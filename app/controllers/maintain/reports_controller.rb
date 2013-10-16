class Maintain::ReportsController < Maintain::ApplicationController
  #before_filter :get_report_search, :except => [:index]
  

  
  
  def index
  end
  
  
  # -------------------------
  # sales reports
  # -------------------------
  def sale_details_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'sale_category'
    @search.by_product = true
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:sales] = {}
    @conditions[:sales][:created_at] = [@search.from_date..@search.to_date]
    @conditions[:sales][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:sales][:category] = @search.category if @search.category != 'all'
    
    @conditions[:products] = {} if @search.product_name.present?
    @conditions[:products][:name] = @search.product_name if @search.product_name.present?
    
    @sales = Sale.find(:all,
                       :select => " sales.*, sale_details.*, measurements.name as measurement, products.name as product_name, stores.name as store_name, lookups.description as category_name, users.name as user_name",
                       :from => " sales inner join sale_details on sales.id=sale_details.sale_id
                        inner join products on sale_details.product_id = products.id
                        inner join measurements on products.measurement_id = measurements.id
                        inner join stores on sales.store_id = stores.id
                        inner join lookups on sales.category = lookups.code and lookups.category = 'sale_category'
                        inner join users on sales.user_id = users.id ",
                       :conditions => @conditions,
                       :order => " sale_details.id desc "
                       ) 
    
  end
  
  
  
  
  def sale_products_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'sale_category'
    @search.by_product = true
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:sales] = {}
    @conditions[:sales][:created_at] = @search.date_range
    @conditions[:sales][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:sales][:category] = @search.category if @search.category != 'all'
    
    @conditions[:products] = {} if @search.product_name.present?
    @conditions[:products][:name] = @search.product_name if @search.product_name.present?
    
    @sales = Sale.find(:all,
                       :select => " sale_details.product_id, measurements.name as measurement, products.name as product_name, sum(sale_details.quantity) as quantity",
                       :from => " sales inner join sale_details on sales.id=sale_details.sale_id
                        inner join products on sale_details.product_id = products.id 
                        inner join measurements on products.measurement_id = measurements.id ",
                       :conditions => @conditions,
                       :group => " sale_details.product_id, measurements.name, products.name ",
                       :order => " quantity desc "
                       ) 
    
    
  end
  
  
  
  def sale_amount_by_store_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'sale_category'
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:sales] = {}
    @conditions[:sales][:created_at] = @search.date_range
    @conditions[:sales][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:sales][:category] = @search.category if @search.category != 'all'
    
    
    @sales = Sale.find(:all,
                       :select => " stores.name store_name, sum(sales.actual_amount) as actual_amount",
                       :from => " sales inner join stores on sales.store_id = stores.id",
                       :conditions => @conditions,
                       :group => " stores.name ",
                       :order => " actual_amount desc "
                       ) 
    
  end
  
  def sale_amount_by_user_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'sale_category'
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:sales] = {}
    @conditions[:sales][:created_at] = @search.date_range
    @conditions[:sales][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:sales][:category] = @search.category if @search.category != 'all'
    @conditions[:sales][:category] = Lookup.where(:category => 'sale_category').map{|c| [c.description, c.code]}.delete_if{|x| x[1] == 'O'} if @search.category == 'all'
    
    
    @sales = Sale.find(:all,
                       :select => " users.name as user_name, sum(sales.actual_amount) as actual_amount",
                       :from => " sales inner join users on sales.user_id=users.id",
                       :conditions => @conditions,
                       :group => " users.name ",
                       :order => " actual_amount desc "
                       ) 
  end
  
  
  
  def sale_discount_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'sale_category'
    @search.by_product = true
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:sales] = {}
    @conditions[:sales][:created_at] = @search.date_range
    @conditions[:sales][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:sales][:category] = @search.category if @search.category != 'all'
    
    @conditions[:products] = {} if @search.product_name.present?
    @conditions[:products][:name] = @search.product_name if @search.product_name.present?
    
    @sales = Sale.find(:all,
                       :select => " sales.*,  stores.name as store_name, lookups.description as category_name, users.name as user_name,
                       case when (sales.amount - sales.used_score) > 0 then ((sales.actual_amount - sales.score) / (sales.amount - sales.used_score))
                       else 0 end as discount,
                       members.name as member_name, members.level as member_level ",
                       :from => " sales inner join stores on sales.store_id = stores.id and sales.category in ('M','R') 
                        inner join lookups on sales.category = lookups.code and lookups.category = 'sale_category'
                        left join members on sales.member_id = members.id
                        inner join users on sales.user_id = users.id ",
                       :conditions => @conditions,
                       :order => " discount asc "
                       ) 
  end
  
  
  
  # -------------------------
  # expenses reports
  # -------------------------
  def expense_details_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'expense_category'
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:expenses] = {}
    @conditions[:expenses][:created_at] = @search.date_range
    @conditions[:expenses][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:expenses][:category] = @search.category if @search.category != 'all'
    
    
    @expenses = Expense.find(:all,
                       :select => " expenses.*,  stores.name as store_name, lookups.description as category_name, users.name as user_name",
                       :from => " expenses 
                        inner join stores on expenses.store_id = stores.id
                        inner join lookups on expenses.category = lookups.code and lookups.category = 'expense_category'
                        inner join users on expenses.user_id = users.id ",
                       :conditions => @conditions,
                       :order => " expenses.id desc "
                       ) 
  end
  
  
  def expense_amount_by_store_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'expense_category'
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:expenses] = {}
    @conditions[:expenses][:created_at] = @search.date_range
    @conditions[:expenses][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:expenses][:category] = @search.category if @search.category != 'all'
    
    @expenses = Expense.find(:all,
                       :select => " stores.name store_name, sum(expenses.amount) as amount",
                       :from => " expenses inner join stores on expenses.store_id = stores.id",
                       :conditions => @conditions,
                       :group => " stores.name ",
                       :order => " amount desc "
                       ) 
    
  end
  
  def expense_amount_by_user_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'expense_category'
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:expenses] = {}
    @conditions[:expenses][:created_at] = @search.date_range
    @conditions[:expenses][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:expenses][:category] = @search.category if @search.category != 'all'
    
    
    @expenses = Expense.find(:all,
                       :select => " users.name as user_name, sum(expenses.amount) as amount",
                       :from => " expenses inner join users on expenses.user_id=users.id",
                       :conditions => @conditions,
                       :group => " users.name ",
                       :order => " amount desc "
                       ) 
  end
  
  
  
  # -------------------------
  # stocks reports
  # -------------------------
  def stock_details_report
    @search = ReportSearch.new
    @search.by_store = true
    @search.by_product = true
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:stocks] = {}
    @conditions[:stocks][:store_id] = @search.store_id if @search.store_id.to_i > 0
    
    @conditions[:products] = {} if @search.product_name.present?
    @conditions[:products][:name] = @search.product_name if @search.product_name.present?
    
    @stocks = Expense.find(:all,
                       :select => " stocks.*,  stores.name as store_name, products.name as product_name, measurements.name as measurement  ",
                       :from => " stocks 
                        inner join stores on stocks.store_id = stores.id
                        inner join products on stocks.product_id = products.id 
                        inner join measurements on products.measurement_id = measurements.id  ",
                       :conditions => @conditions,
                       :order => " stocks.quantity desc "
                       ) 
  end
  
  def stock_movement_histories_report
    @search = ReportSearch.new
    @search.by_date_period = true
    @search.by_store = true
    @search.by_category = true
    @search.category_for = 'adjust_category'
    @search.by_product = true
    
    init_search_menu_and_get_parameters
    
    @conditions = {}
    @conditions[:stocks] = {}
    @conditions[:stocks][:store_id] = @search.store_id if @search.store_id.to_i > 0
    @conditions[:stock_histories] = {}
    @conditions[:stock_histories][:adjusted_at] = @search.date_range
    @conditions[:stock_histories][:adjust_category] = @search.category if @search.category != 'all'
    
    @conditions[:products] = {} if @search.product_name.present?
    @conditions[:products][:name] = @search.product_name if @search.product_name.present?
    
    @stocks = Expense.find(:all,
                       :select => " stocks.*, stock_histories.adjusted_by , stock_histories.adjusted_to, stock_histories.remark, stock_histories.adjusted_at,
                       stores.name as store_name,
                       products.name as product_name, measurements.name as measurement,
                       lookups.description as adjust_category",
                       :from => " stocks 
                        inner join stock_histories on stocks.id = stock_histories.stock_id
                        inner join stores on stocks.store_id = stores.id
                        inner join lookups on stock_histories.adjust_category = lookups.code and lookups.category = 'adjust_category'
                        inner join products on stocks.product_id = products.id 
                        inner join measurements on products.measurement_id = measurements.id  ",
                       :conditions => @conditions,
                       :order => " stock_histories.id desc "
                       ) 
  end
  
  
  
  
  
  
  
  
  
  
  
  # -----------------------------------------------------------
  # init report search 
  # -----------------------------------------------------------
  def init_search_menu_and_get_parameters
    
    if @search.by_date_period
      @search.from_date = params[:from_date] || Date.today.beginning_of_week
      @search.to_date = params[:to_date] || Date.today
    end
    
    
    if @search.by_store
      @stores = Store.all.map{|s| [s.name, s.id]}.insert(0, [t(:all),0])
      @search.store_id = params[:store_id] || 0
    end
    
    if @search.by_category
      @categories = Lookup.where(:category => @search.category_for).map{|c| [c.description, c.code]}.insert(0, [t(:all),'all'])
      @categories.delete_if{|x| x[1]=='O' && @search.category_for == 'sale_category'}
      @search.category = params[:category] || 'all'
    end
    
    
    if @search.by_product
      @search.product_name = params[:product_name] || ''
    end
    
    
    
  end
  
  
 
  
  
end
