class ProductsController < ApplicationController
  #before_filter :require_user  #not must be, ajax data get from here
  before_filter :authenticate_user!
  before_filter :require_handover 
  
  def index
    @category_id = params[:category_id].blank? ? 0 : params[:category_id].to_i

    @products = nil
    @products = Product.for_sale(@category_id,current_user.store_id) if @category_id > 0 
    #@products = where( " category_id = ? ", category_id)
    #@products = Product.for_sale(category_id)
    @cart = Cart.new
    
    session[:category_id] = @category_id
  end
  
  def show
    @product = Product.find(params[:id])
    @stock = Stock.where(" product_id =? and store_id = ? ", @product.id, current_user.store_id).first
    @histories = @stock.nil? ? nil : StockHistory.where(" stock_id =? ", @stock.id).order(" id desc ").limit(16)
    
    @cart = Cart.new(:product_id => @product.id)
    
  end
  
  
  def products_list(category)
    conditions = {}
    conditions[:category_id] = category.id unless category.nil?
    Product.find(:all, :conditions => conditions)
  end
  
  def list_by_category
    category_id = params[:category_id].blank? ? 0 : params[:category_id].to_i
    @products = Product.where(:category_id => category_id).order(" id desc ").map{|c| [c.name, c.id]}.insert(0, t(:all_products))
  end
  
  
end
