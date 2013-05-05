class Maintain::UsersController < Maintain::ApplicationController
  
  def index
    #authorize! :index, @user, :message => t(:not_authorized_as_admin)
    @users = User.paginate(:page => params[:page]).order("id desc")
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save!
      if @user.add_role(:user)
        redirect_to [:maintain,@user], :notice => t(:user_created)
      else
        redirect_to :back, :alert => t(:unable_to_add_role)
      end
    else
      redirect_to :back, :alert => t(:unable_to_create_user)
    end
  end
  
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.account = params[:user][:account]
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    
    if @user.save
      redirect_to [:maintain,@user], :notice => t(:user_updated)
    else
      render :edit #:back, :alert => t(:unable_to_update_user)
    end
  end

  def destroy
    #user = User.find(params[:id])
    #unless user == current_user
    #  user.destroy
    #  redirect_to users_path, :notice => t(:user_deleted)
    #else
    #  redirect_to users_path, :notice => t(:can_not_delete_yourself)
    #end
  end
  
  def lock
    @user = User.find(params[:id])
    @user.status = 0
    if @user.save
      redirect_to [:maintain,@user], :notice => t(:user_locked)
    else
      redirect_to :back, :alert => t(:user_locked_failed)
    end
  end
  
  def unlock
    @user = User.find(params[:id])
    @user.status = 1
    if @user.save
      redirect_to [:maintain,@user], :notice => t(:user_unlocked)
    else
      redirect_to :back, :alert => t(:user_unlocked_failed)
    end
  end
  
end
