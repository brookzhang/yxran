class CartsController < ApplicationController
  def index
    @member = session[:member_id].nil? ? nil : Member.find(session[:member_id])
    @carts = Cart.where(" user_id = ? and store_id = ? ", current_user.id, current_user.store_id)
  end

  def new
    @cart = Cart.new(params[:cart])
    @cart.store_id = current_user.store_id
    @cart.user_id = current_user.id
    @cart.save
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
