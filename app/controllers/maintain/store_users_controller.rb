class Maintain::StoreUsersController < ApplicationController
  def index
    @store_users = StoreUser.all.order(' store_id asc ')
  end

  def new
    @store_user = StoreUser.new
    @users = User.all.order('id desc')
    @stores = Store.all
  end

  def create
    @store_user = StoreUser.new(params[:store_user])
    if @store_user.save
      redirect_to maintain_store_users_path
    else
      @users = User.all.order('id desc')
      @stores = Store.all 
      render 'new'
    end
    
  end

  def edit
    @users = User.all.order('id desc')
    @stores = Store.all
    @store_user = StoreUser.find(params[:id])
  end

  def update
    @store_user = StoreUser.find(params[:id])
    if @store_user.update_attributes(params[:store_user])
      redirect_to maintain_store_users_path
    else
      @users = User.all.order('id desc')
      @stores = Store.all
      render 'edit'
    end
    
  end

  def destroy
    @store_user = StoreUser.find(params[:id])
    if @store_user.destroy
      redirect_to maintain_store_users_path
    else
      redirect_to :back, :alert => t(:unable_to_delete)
    end
    
  end
end
