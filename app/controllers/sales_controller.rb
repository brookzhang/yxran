class SalesController < ApplicationController
  def index
    @sales = Sale.all
  end
  
  def show
    @sale = Sale.find(params[:id])
  end

  def new
    @sale = Sale.new
    @sale.category = params[:category].nil? ? 'N' : params[:category]
  end
  

  def create
    @sale = Sale.new(params[:sale])
    if @sale.save
      redirect_to sales_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @sale = Sale.find(params[:id])
  end

  def update
    @sale = Sale.find(params[:id])
    if @sale.update_attributes(params[:sale])
      redirect_to sale_path(@sale), :notice => t(:updated_ok)
    else
      redirect_to sale_path(@sale), :alert => t(:unable_to_update)
    end
  end
end
