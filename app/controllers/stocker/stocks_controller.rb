class Stocker::StocksController < Stocker::ApplicationController
  def index
    @category_id = params[:category_id].blank? ? 0 : params[:category_id].to_i
    
    @stores = Store.authorized_stores(current_user.id, 'stocker')

    @stocks = Stock.in_category(@category_id)
    @stocks = @stocks.in_store(params[:store_id]) if params[:store_id].present?
    @stocks = @stocks.where(:store_id => @stores.map(&:id)) if params[:store_id].blank?
    @stocks = @stocks.by_product(params[:product_name]) unless params[:product_name].blank?
    @stocks = @stocks.paginate(:page => params[:page], :per_page => 10).order('id DESC')
    
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
