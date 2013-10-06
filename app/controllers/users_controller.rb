class UsersController < ApplicationController
  before_filter :get_user, :only => [:show, :edit, :update, :update_password] 
  before_filter :require_owner, :only => [:show, :edit, :update, :update_password]
  
  def show
    #@user = User.find(current_user.id)
  end
  
  def edit
    #@user = User.find(current_user.id)
  end

  def update
    #@user = User.find(current_user.id)
    if @user.update_with_password(params[:user])
      redirect_to @user, :notice => t(:user_updated)
    else
      render :edit
    end
  end
  
  def update_password
    #@user = User.find(current_user.id)
    
    if @user.update_with_password(params[:user])
      # Sign in the user by passing validation in case his password changed

      sign_in @user, :bypass => true
      redirect_to @user, :notice => t(:password_changed_successfully)
    else
      render :edit
     
    end
  end
  
  
  
  protected
  def get_user
    @user = User.find(current_user.id)
  end

end
