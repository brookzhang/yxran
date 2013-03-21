class CartsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    session[:member_id] = params[:member_id] unless params[:member_id].nil?
    session[:member_id] = nil if params[:dismiss] == '1'
    
    @member = session[:member_id].nil? ? nil : Member.find(session[:member_id])
    @carts = Cart.list_by_user(current_user)
    @sum_amount = 0
    @sum_used_score = 0
    @carts.each {|c| @sum_amount += c.amount; @sum_used_score += c.used_score}
    
    
  end


  def create
    @cart = Cart.new(params[:cart])
    @cart.store_id = current_user.store_id
    @cart.user_id = current_user.id
    @cart.used_score = 0
    @cart.amount = @cart.quantity * @cart.product.unit_price
    @cart.save
    
    session[:cart_count] = Cart.count_by_user(current_user).to_s
    
    redirect_to products_path(:category_id => @cart.product.category_id) # carts_path #, :notice => t(:add_ok)
  end


  def edit
    @cart = Cart.find(params[:id])
    @member = session[:member_id].nil? ? nil : Member.find(session[:member_id])
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
