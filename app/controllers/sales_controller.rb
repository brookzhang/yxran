class SalesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @sales = Sale.all
  end
  
  def show
    @sale = Sale.find(params[:id])
  end

  def new
    session[:category] = params[:category] unless params[:category].nil?
    session[:member_id] = params[:member_id] unless params[:member_id].nil?
    session[:member_id] = nil if session[:category] != "M" || params[:dismiss] == '1'

    
    
    
    
    @sale = Sale.new
    @sale.category = session[:category]
    @sale.member_id = session[:member_id].nil? ? nil : session[:member_id].to_i
    
    @member = @sale.member_id.nil? ? nil : Member.find(@sale.member_id) 
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    
    
  end
  

  def create
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    
    @sale = Sale.new(params[:sale])
    if @sale.create(@carts)
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
