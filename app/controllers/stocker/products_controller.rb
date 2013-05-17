class Stocker::ProductsController < Stocker::ApplicationController

  def index
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new
    
    
    @product = Product.new(params[:product])
    category_id = @product.category_id.nil? ? 0 : @product.category_id
    category_id = category_id == 0 ? (@product.super_category_id.nil? ? 0 : @product.super_category_id) : category_id
    
    @products = Product.in_category(category_id).by_name(@product.name).paginate(:page => params[:page], :per_page => 5).order(" id desc ")
    
    @array_super = Category.where(:parent_id => 0).map{|c|[c.name,c.id]}.insert(0, t(:super_category))
    @array_sub = @product.super_category_id.nil? && @product.super_category_id == 0 ? [] : Category.where(:parent_id => @product.super_category_id).map{|c|[c.name,c.id]}
    @array_sub.insert(0, t(:category))
    
    
    
  end
  
  def show
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new
    
    @product = Product.find(params[:id])
    @stock = Stock.where(" product_id =? and store_id = ? ", @product.id, current_user.store_id).first
    @histories = @stock.nil? ? nil : StockHistory.where(" stock_id =? ", @stock.id)
    
    
  end
  
  
  
  
  
  
  
  
  
  
  
  
end
