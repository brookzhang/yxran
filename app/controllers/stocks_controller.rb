class StocksController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    category_id = params[:category_id].blank? ? 0 : params[:category_id].to_i
    @top_categories = Category.where(:parent_id => 0)
    @current_category = category_id == 0 ? nil : Category.find(category_id)
    
    
    @stock = Stock.new
    @stocks = Stock.in_store(current_user.store.id).in_category(category_id).has_stock.paginate(:page => params[:page], :per_page => 8).order('id DESC')
    
    
  end
  
  
  
end
