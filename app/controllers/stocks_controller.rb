class StocksController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    category_id = params[:category_id].nil? ? 0 : params[:category_id].to_i
    @category = category_id == 0 ? nil : Category.find(category_id)
    @categories = Category.where(" parent_id = ? ", category_id )
    
    
    @stock = Stock.new
    @stocks = Stock.in_store(current_user.store.id).by_category(category_id).has_stock.paginate(:page => params[:page], :per_page => 5).order('id DESC')
    
    @cart = Cart.new
    
  end
  
  
  
end
