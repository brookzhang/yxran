class Stocker::ProductsController < Stocker::ApplicationController

  def index
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new
    
    category_id =  (params[:category_id].nil? || params[:category_id].empty?) ? 0 : params[:category_id].to_i
    
    category_id = params[:category_id].nil? ? 0 : params[:category_id].to_i
    @products = Product.in_category(category_id).paginate(:page => params[:page], :per_page => 5)
    
    @category = category_id == 0 ? nil : Category.find(category_id)
    @categories = Category.where(" parent_id = ? ", category_id )
    

  end
  
  def show
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new
    
    @product = Product.find(params[:id])
    @stock = Stock.where(" product_id =? and store_id = ? ", @product.id, current_user.store_id).first
    @histories = @stock.nil? ? nil : StockHistory.where(" stock_id =? ", @stock.id)
    
    
  end
  
  
  
  def new
    @order = Order.find(params[:order_id])
    @product = Product.new
    
    @super_categories = Category.where(:parent_id => 0) #.map{ |c| [c.name, c.id]}
    @categories = []
    
  end
  
  
  def update_sub_categories
    parent_id =  (params[:parent_id].nil? || params[:parent_id].empty?) ? 0 : params[:parent_id].to_i
    
    if parent_id == 0
      @categories = []
    else
      @categories = Category.where(:parent_id => parent_id).map{|c| [c.name, c.id]}.insert(0, t(:choose_category))
    end
    
  end
  
  
  
end
