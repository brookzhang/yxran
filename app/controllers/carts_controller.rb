class CartsController < ApplicationController
  
  before_filter :require_user
  before_filter :require_handover 
  
  def index
    
    @carts = Cart.list_by_user(current_user)
    session[:cart_count] = @carts.count
    @sum_amount = @carts.sum {|c| c.amount.nil? ? 0 : c.amount  }
    @store = Store.find(current_user.store_id)
    
  end

  def new
    product = Product.find(params[:product_id])
    @cart = Cart.new
    @cart.store_id = current_user.store_id
    @cart.user_id = current_user.id
    @cart.product_id = product.id
    @cart.unit_price = @cart.product.unit_price(current_user.store_id)
  end


  def create
    pre_category_id = session[:category_id].nil? ? 0 : session[:category_id]
    
    @cart = Cart.new(params[:cart])
    @cart.quantity = 0 if @cart.quantity.blank?

    @cart.store_id = current_user.store_id
    @cart.user_id = current_user.id
    @cart.unit_price = @cart.product.unit_price(current_user.store_id)
    @cart.amount = @cart.quantity * @cart.unit_price
    if @cart.save
      session[:cart_count] = Cart.count_by_user(current_user).to_s
      redirect_to stocks_path(:category_id => pre_category_id) , :notice => t(:add_ok)
    else
      redirect_to stocks_path(:category_id => pre_category_id) , :alert => t(:add_failed)
    end
  end


  def edit
    @cart = Cart.find(params[:id])
  end


  def update
    @cart = Cart.find(params[:id])
    @cart.quantity = params[:cart][:quantity]
    @cart.amount = @cart.quantity * @cart.unit_price
    
    
    if @cart.save
      session[:cart_count] = Cart.count_by_user(current_user).to_s
      redirect_to carts_path, :notice => t(:edit_cart_successfully)
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
  
  
  
end
