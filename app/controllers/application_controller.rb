class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  before_filter :authenticate_user! #, :only => [:show]
  before_filter :check_duty_period
  
  check_authorization :unless => :do_not_check_authorization?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_path, :alert => exception.message
  end
  
  WillPaginate.per_page = 5
  
  around_filter :transactional, :except => [:index, :show, :new, :edit]

  
  
  protected
  # relies on the presence of an instance variable named after the controller
  def require_owner
    #object = instance_variable_get("@#{controller_name.singularize.camelize.underscore}") 
    object = instance_variable_get("@#{self.controller_name.singularize}")
    unless current_user && object.is_owned_by?(current_user)
      redirect_to root_path, :alert => t(:you_have_no_access_with_this)
    end
  end
  
  def require_user
    if !current_user.has_role?(:user)
      redirect_to root_path, :alert => t(:only_allow_user_in)
    end
  end
  
  def require_manager
    if !current_user.has_role?(:manager)
      redirect_to root_path, :alert => t(:only_allow_stocker_in)
    end
  end

  def require_handover
    if current_user.store_id.nil?
      redirect_to root_path, :alert => t(:you_should_take_over_a_store_first)
    end
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

  def transactional
    ActiveRecord::Base.transaction do
      yield
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, request)
  end


  def check_duty_period
    # if current_user.from_time.present? && current_user.to_time.present?
      
    # else
    #   true
    # end
  end
  
  
  
  
end
