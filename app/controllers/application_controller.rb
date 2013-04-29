class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  before_filter :authenticate_user! #, :only => [:show]
  
  check_authorization :unless => :do_not_check_authorization?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_path, :alert => exception.message
  end
  
  
  
  
  private
  def do_not_check_authorization?
    respond_to?(:devise_controller?) or
    condition_one? or
    condition_two?
  end

  def condition_one?
   #
  end

  def condition_two?
   #
  end
  
  def set_locale
    
    I18n.locale = 'zh-CN'
    #Time.zone = ActiveSupport::TimeZone[session[:timezone_offset]] if session[:timezone_offset]
    #if current_user.present? and (locale = current_user.preference[:locale]).present?
    #  I18n.locale = locale
    #end
    
  end
  
  
  
  
end
