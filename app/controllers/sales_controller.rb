class SalesController < ApplicationController
  
  before_filter :get_sale, :only => [:show, :edit, :update] 
  before_filter :require_owner, :only => [:show, :edit, :update]
  
  def index
    @sales = Sale.where(:user_id => current_user.id).paginate(:page => params[:page]).order('id DESC')
  end
  
  def show
    @sale = Sale.find(params[:id])
    @sale_details = SaleDetail.where( :sale_id => @sale.id)
    @member = @sale.member_id.nil? ? nil : Member.find(@sale.member_id)
  end
  
  
  def retail
    #retail sale, no discount
    @sale = Sale.new(:category => 'R')
    @carts = Cart.list_by_user(current_user)
    @sale.actual_amount = @carts.sum {|c| c.amount.nil? ? 0 : c.amount }
    
  end
  
  
  def cost()
    #cost record, no money income
    @sale = Sale.new(:category => 'C')
    @carts = Cart.list_by_user(current_user)
    
  end


  def new
    #the most sale type, sale to members
    session[:member_id] = params[:member_id] unless params[:member_id].nil?
    
    @sale = Sale.new(:category => 'M')
    @sale.member_id = session[:member_id].nil? ? nil : session[:member_id].to_i
    
    @member = @sale.member_id.nil? ? nil : Member.find(@sale.member_id) 
    @carts = Cart.list_by_user(current_user)
    @amount = @carts.sum {|c| c.amount.nil? ? 0 : c.amount }
    
  end
  

  def create
    @carts = Cart.list_by_user(current_user)
    
    @sale = Sale.new(params[:sale])
    @sale.user_id = current_user.id
    @sale.store_id = current_user.store_id
    
    if @sale.create_sale(@carts)
      session[:cart_count] = 0
      session[:member_id] = nil
      redirect_to sales_path, :notice => t(:created_ok)
    else
      case @sale.category
      when "C"
        render :cost
      when "R"
        render :retail
      when "M"
        render :new
      else
        render :new
      end 
      #redirect_to :back, :alert => t(@sale.check_message)
    end   
    
    
    
  end



  def edit
    #@sale = Sale.find(params[:id])
  end

  def update
    #@sale = Sale.find(params[:id])
    #if @sale.update_attributes(params[:sale])
    #  redirect_to sale_path(@sale), :notice => t(:updated_ok)
    #else
    #  redirect_to sale_path(@sale), :alert => t(:unable_to_update)
    #end
  end
  
  def cancel
    @sale = Sale.find(params[:id])
    if @sale.cancel
      redirect_to sales_path, :notice => t(:sale_canceled_ok)
    else
      redirect_to :back, :alert => t(@sale.check_message)
    end
  end
  
  
  protected
  def get_sale
    @sale = Sale.find(params[:id])
  end
  
  
end
