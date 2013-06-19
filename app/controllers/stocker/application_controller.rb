class Stocker::ApplicationController < ApplicationController
  before_filter :require_stocker
  
  
  WillPaginate.per_page = 10
  
  
  
  private

  #----------------------------------------------------------------------------
  def require_stocker
    unless current_user.has_role?(:stocker) || current_user.has_role?(:manager)
      redirect_to root_path, :alert => t(:only_allow_stocker_in)
    end
  end
  
end
