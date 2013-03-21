class CartsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    
    @carts = Cart.list_by_user(current_user)
    @sum_amount = @carts.sum {|c| c.amount  } 
    @sum_score = @carts.sum {|c| c.score  } 
    
  end


  def create
    @cart = Cart.new(params[:cart])
    @cart.store_id = current_user.store_id
    @cart.user_id = current_user.id
    @cart.score = 0
    @cart.amount = @cart.quantity * @cart.product.unit_price
    @cart.save
    
    session[:cart_count] = Cart.count_by_user(current_user).to_s
    
    redirect_to products_path(:category_id => @cart.product.category_id) # carts_path #, :notice => t(:add_ok)
  end


  def edit
    @cart = Cart.find(params[:id])
  end


  def update
    @cart = Cart.find(params[:id])
    @cart.quantity = params[:cart][:quantity]
    if params[:cart][:amount].to_f == @cart.amount
      @cart.amount = @cart.quantity * @cart.product.unit_price
    else
      @cart.amount = params[:cart][:amount]
    end
    
    
    if @cart.save
      session[:cart_count] = Cart.count_by_user(current_user).to_s
      redirect_to carts_path, :notice => t(:updated_ok)
    else
      redirect_to :back, :alert => t(:unable_to_update)
    end
  end


  def destroy
    @cart = Cart.find(params[:id])
    if @cart.destroy
      session[:cart_count] = Cart.count_by_user(current_user).to_s
      redirect_to carts_path
    else
      redirect_to :back, :notice => t(:unable_to_delete)
    end
  end
  
  def switch_discount
    redirect_to carts_path
  end
  
  
end
