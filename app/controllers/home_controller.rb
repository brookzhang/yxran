class HomeController < ApplicationController
  before_filter :authenticate_user! #, :only => [:show]
  
  def index
    @users = User.all
  end
  
  def show
    
  end
end
