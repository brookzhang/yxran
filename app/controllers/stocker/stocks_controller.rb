class Stocker::StocksController < Stocker::ApplicationController
  def index
    @stock = Stock.new
    @stock.store_id = params[:store_id]
    @stock.product_name = params[:product_name]
    @stores = Store.all
    @stocks = Stock.in_store(params[:store_id]).by_product(params[:product_name]).paginate(:page => params[:page], :per_page => 8).order('id DESC')
    
  end
  
  def show
    @stock = Stock.find(params[:id])
    @histories = StockHistory.where(" stock_id =? ", @stock.id).paginate(:page => params[:page], :per_page => 5).order('id DESC')
  end



  def edit
    @stock = Stock.find(params[:id])
    @stock.unit_price = @stock.price_of_product
  end

  def update
    @stock = Stock.find(params[:id])
    @stock.unit_price = params[:stock][:unit_price] == @stock.price_of_product ? nil : params[:stock][:unit_price]
    if @stock.update_attributes(params[:stock])
      redirect_to stocker_stock_path(@stock), :notice => t(:updated_ok)
    else
      redirect_to stocker_stock_path(@stock), :alert => t(:unable_to_update)
    end
  end
  

  
end
