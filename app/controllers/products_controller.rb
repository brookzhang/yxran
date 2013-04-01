class ProductsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    category_id = params[:category_id].nil? ? 0 : params[:category_id].to_i
    @category = category_id == 0 ? nil : Category.find(category_id)
    @categories = Category.where(" parent_id = ? ", category_id )
    @products = Product.list_with_sub_category(category_id)
    #@products = where( " category_id = ? ", category_id)
    @cart = Cart.new
    
    session[:category_id] = category_id
  end
  
  def show
    @product = Product.find(params[:id])
    @stock = Stock.where(" product_id =? and store_id = ? ", @product.id, current_user.store_id).first
    @histories = @stock.nil? ? nil : StockHistory.where(" stock_id =? ", @stock.id)
    
    @cart = Cart.new
    
  end
  
  
  def products_list(category)
    conditions = {}
    conditions[:category_id] = category.id unless category.nil?
    Product.find(:all, :conditions => conditions)
  end
end
