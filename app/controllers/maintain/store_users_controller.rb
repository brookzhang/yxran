class Maintain::StoreUsersController < ApplicationController


  def new
    @user = User.find(params[:user_id])
    @store_user = StoreUser.new(:store_id => params[:store_id], :user_id => params[:user_id])
    @stores = Store.all
    @arr_role_store = StoreUser.where(:user_id => @user.id).map{|ss| ss.role + '_' + ss.store_id.to_s}
      

  end

  def create
    @user = User.find(params[:user_id])
    @stores = Store.all

    StoreUser.where(:user_id => @user.id).each(&:destroy)
    unless params[:store_user].empty?
      @user.roles.each do |role|
        unless params[:store_user][role.name].empty?
          
          params[:store_user][role.name].each do |store_id|
            @store_user = StoreUser.new
            @store_user.user_id = @user.id
            @store_user.store_id = store_id
            @store_user.role = role.name 
            @store_user.save
          end
        end

      end
    end

    redirect_to maintain_user_path(@user)

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
