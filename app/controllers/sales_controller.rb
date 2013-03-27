class SalesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @sales = Sale.where(:user_id => current_user.id).order(" id desc ") 
  end
  
  def show
    @sale = Sale.find(params[:id])
    @sale_details = SaleDetail.where( :sale_id => @sale.id)
  end
  
  
  def retail
    #retail sale, no discount
    @sale = Sale.new(:category => 'R')
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    
  end
  
  
  def cost()
    #cost record, no money income
    @sale = Sale.new(:category => 'C')
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    
  end


  def new
    #the most sale type, sale to members
    session[:member_id] = params[:member_id] unless params[:member_id].nil?

    
    
    
    
    @sale = Sale.new(:category => 'M')
    @sale.member_id = session[:member_id].nil? ? nil : session[:member_id].to_i
    
    @member = @sale.member_id.nil? ? nil : Member.find(@sale.member_id) 
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    
    
  end
  

  def create
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    
    @sale = Sale.new(params[:sale])
    
    if @sale.create_sale(@carts)
      session[:cart_count] = Cart.count_by_user(current_user).to_s
      redirect_to sales_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create) + @sale.store_id.to_s
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
