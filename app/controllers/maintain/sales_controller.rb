class Maintain::SalesController < ApplicationController
  def index
    @sales = Sale.all
  end
  
  def show
    @sale = Sale.find(params[:id])
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
