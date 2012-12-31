class StocksController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @stock = Stock.new
    @stock.store_id = current_user.store.id
    @stock.product_id = params[:product_id]
    @stocks = find_stocks(@stock)
    
  end
  
  
  
  private
  def find_stocks(stock)
    conditions = {}
    conditions[:store_id] = stock.store_id unless stock.store_id.nil?
    conditions[:product_id] = stock.product_id unless stock.product_id.nil?
    Stock.find(:all, :conditions => conditions)
  end
end
