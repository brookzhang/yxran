class Maintain::ApplicationController < ApplicationController
  before_filter :require_manager
  
  
  WillPaginate.per_page = 10
  
  
  private

  #----------------------------------------------------------------------------
  def require_manager
    if !current_user.has_role?(:manager)
      redirect_to root_path, :alert => t(:only_allow_manager_in)
    end
  end
  
end
