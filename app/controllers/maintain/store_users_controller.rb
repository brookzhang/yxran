class Maintain::StoreUsersController < ApplicationController
  def index
    @store_users = StoreUser.order(' id desc ').paginate(:page => params[:page])
  end

  def new
    @store_user = StoreUser.new
    @users = User.order('id desc')
    @stores = Store.all
    @roles = Lookup.where(:category => 'role')
  end

  def create
    @store_user = StoreUser.new(params[:store_user])
    if @store_user.save
      redirect_to maintain_store_users_path
    else
      @users = User.order('id desc')
      @stores = Store.all 
      @roles = Lookup.where(:category => 'role')
      render 'new'
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
