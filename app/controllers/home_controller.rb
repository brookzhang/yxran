class HomeController < ApplicationController
  before_filter :authenticate_user! #, :only => [:show]
  
  def index
    #session[:member_id] = 100
    #session.delete :member_id
    
    
    if current_user.has_role? :user
      session[:cart_count] = Cart.count_by_user(current_user).to_s if session[:cart_count].nil?
      
    end
    
    if current_user.has_role? :manager
      @stores = Store.all
      @handovers = Handover.limit(10).order(" id desc ")
      
    end
    
    
    if current_user.has_role? :admin
      
      
    end
    
    
    
    
  end
  
end
