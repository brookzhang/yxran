class Maintain::StocksController < ApplicationController
  def index
    @store = Store.find(params[:store_id])
    @stocks = Stock.where("store_id= ?",@store.id)
  end
  
  def show
    @stock = Stock.find(params[:id])
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
  
end
