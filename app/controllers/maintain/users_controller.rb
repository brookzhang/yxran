class Maintain::UsersController < Maintain::ApplicationController
  
  def index
    #authorize! :index, @user, :message => t(:not_authorized_as_admin)
    if current_user.has_role?(:admin)
      @users = User.paginate(:page => params[:page]).order("id desc")
    else 
      @users = User.employees.where(" true) or users.id = ? and ( true", current_user.id).paginate(:page => params[:page]).order("id desc")
    end
    
  end

  def show
    @user = User.find(params[:id])
    @store_users = StoreUser.where(:user_id => @user.id).includes(:user)
    @roles = @user.roles
    
  end
  
  def new
    @user = User.new
    @user.role = 'user'
    @roles = Lookup.list("role_category").where(:code => [:user, :stocker]).map{|r| [r.description, r.code]}
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to [:maintain,@user], :notice => t(:user_created)
    else
      @roles = roles_allowed
      render :new
    end
  end
  
  
  def edit
    @user = User.find(params[:id])
    @user.role = @user.roles.map{|r| r.name}
    @roles = roles_allowed
  end

  def update
    @user = User.find(params[:id])
    @user.account = params[:user][:account]
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password] unless params[:user][:password].blank?
    #@user.role = params[:user][:role].inject{|r,result| result + ',' + r unless r.blank? }
    @user.role = params[:user][:role].delete_if{|r| r.blank?}.join(",")
    #@user.role = @user.role.blank? ? nil : @user.role
    
    #render :text => @user.role
    if @user.save
      redirect_to [:maintain,@user], :notice => t(:user_updated)
    else
      @roles = roles_allowed
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
  
  
  
  
  
  private
  def roles_allowed
    if current_user.has_role?(:admin)
      roles = Lookup.list("role_category").map{|r| [r.description, r.code]}
    else
      roles = Lookup.list("role_category").where(:code => [:user, :stocker]).map{|r| [r.description, r.code]}
    end
    roles
    
  end
  
end
