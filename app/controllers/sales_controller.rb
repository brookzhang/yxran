class SalesController < ApplicationController
  def index
    @sales = Sale.all
  end
  
  def show
    @sale = Sale.find(params[:id])
  end
  
  def cost_sale
    @sale = Sale.new
    @sale.category = 'C'
  end
  
  def member_sale
    @sale = Sale.new
    @sale.member_id = params[:member_id]
    @sale.category = 'M'
  end

  def new
    @sale = Sale.new
    @sale.category = 'N'
  end
  

  def create
    @sale = Sale.new(params[:sale])
    @sale.user_id = current_user.id
    if @sale.sale_add
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
