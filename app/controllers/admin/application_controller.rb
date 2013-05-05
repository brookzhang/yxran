class Admin::ApplicationController < ApplicationController
  before_filter :require_admin
  
  
  
  
  
  private

  #----------------------------------------------------------------------------
  def require_admin
    if !current_user.has_role?(:admin)
      redirect_to root_path, :alert => t(:only_allow_admin_in)
    end
  end
  
end
