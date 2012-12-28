class HomeController < ApplicationController
  before_filter :authenticate_user! #, :only => [:show]
  
  def index
    #session[:member_id] = 100
    #session.delete :member_id 
  end
  
  def show
    
  end
end
