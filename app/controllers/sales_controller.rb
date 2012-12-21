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
  
  private
  
  def new_sale_save(sale)
    @member = sale.member_id.nil? ? nil : Member.find(sale.member_id)
    @store = Store.find(sale.store_id)
    sale.transaction do
      @member.add_score(sale.score)
      @store.subtract(sale.quantity)
      
    end
  end
end
