class SalesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @sales = Sale.all
  end
  
  def show
    @sale = Sale.find(params[:id])
  end

  def new
    @sale = Sale.new
    #@sale.category = params[:category]
    
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    @member = session[:member_id].nil? ? nil : Member.find(session[:member_id])
    
  end
  

  def create
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    @member = session[:member_id].nil? ? nil : Member.find(session[:member_id])
    
    @sale = Sale.new(params[:sale])
    if @sale.create(@carts , @member)
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
