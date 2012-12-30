class CartsController < ApplicationController
  def index
    @member = session[:member_id].nil? ? nil : Member.find(session[:member_id])
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
    @count = Cart.count 
  end

  def new
    @cart = Cart.new(params[:cart])
    @cart.store_id = current_user.store_id
    @cart.user_id = current_user.id
    @cart.save
    
    session[:cart_count] = Cart.count.to_s
    
    redirect_to carts_path, :notice => t(:add_ok)
  end

  def create
  end

  def edit
  end

  def update
    
  end
  
  def multi_update
    
  end

  def destroy
  end
end
