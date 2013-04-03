class HomeController < ApplicationController
  before_filter :authenticate_user! #, :only => [:show]
  
  def index
    #session[:member_id] = 100
    #session.delete :member_id
    if session[:cart_count].nil?
      session[:cart_count] = Cart.count_by_user(current_user).to_s
    end
    
    
  end
  
  def show
    
  end
end
