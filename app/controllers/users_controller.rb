class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    @stores = Store.all
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @store = Store.find(params[:user][:store_id])
    unless @store.nil?
      if current_user.store_id != @store.id
        current_user.store_id = @store.id
        session[:cart_count] = Cart.count_by_user(current_user).to_s
      end
    end
    
    
    if @user.update_attributes(params[:user])
      redirect_to @user, :notice => t(:user_updated)
    else
      redirect_to @user, :alert => t(:unable_to_update_user)
    end
  end

end
