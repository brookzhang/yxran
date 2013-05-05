class Admin::UsersController < Admin::ApplicationController
  
  def index
    #authorize! :index, @user, :message => t(:not_authorized_as_admin)
    @users = User.paginate(:page => params[:page]).order("id desc")
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
    
  end

  def update
    authorize! :update, @user, :message => t(:not_authorized_as_admin)
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to @user, :notice => t(:user_updated)
    else
      redirect_to @user, :alert => t(:unable_to_update_user)
    end
  end

  def destroy
    authorize! :destroy, @user, :message => t(:not_authorized_as_admin)
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => t(:user_deleted)
    else
      redirect_to users_path, :notice => t(:can_not_delete_yourself)
    end
  end
end
