class Maintain::StocksController < Maintain::ApplicationController
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

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(params[:stock])
    if @stock.save
      redirect_to maintain_stocks_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @stock = Stock.find(params[:id])
  end

  def update
    @stock = Stock.find(params[:id])
    if @stock.update_attributes(params[:stock])
      redirect_to maintain_stock_path(@stock), :notice => t(:updated_ok)
    else
      redirect_to maintain_stock_path(@stock), :alert => t(:unable_to_update)
    end
  end
  
  private
  def find_stocks(stock)
    conditions = {}
    conditions[:store_id] = stock.store_id unless stock.store_id.nil?
    conditions[:product_id] = stock.product_id unless stock.product_id.nil?
    Stock.find(:all, :conditions => conditions)
  end
  
end
