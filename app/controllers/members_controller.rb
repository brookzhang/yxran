class MembersController < ApplicationController
  before_filter :require_user
  #before_filter :get_member, :only => [:show] 
  #before_filter :require_owner, :only => [:show, :edit, :update, :cancel]
  
  def index
    @member = Member.new
    @member.name = params[:name]
    @member.phone = params[:phone]
    
    #@members = members_search(@member)
    #@members = Member.by_name(params[:name]).by_phone(params[:phone]).paginate(:page => params[:page], :per_page => 5).order('id DESC')
    
    if (params[:name].nil? || params[:name].empty?) && (params[:phone].nil? || params[:phone].empty?)
      @members = nil
    else
      @members = Member.by_name(params[:name]).by_phone(params[:phone]).paginate(:page => params[:page], :per_page => 8).order('id DESC')#.limit(5)
    end
    
  end
  
  def view
    @member = Member.find_by_uuid(params[:uuid])
    @histories = Sale.where(:member_id => @member.id).paginate(:page => params[:page], :per_page => 10).order('id DESC')
    
  end
  
  #def show
  #  @member = Member.find(params[:id])
  #end
  
  def new
    @member = Member.new
    @member.name = params[:name]
    @member.phone = params[:phone]
  end

  def create
    @member = Member.new(params[:member])
    @member.level = 0
    @member.score = 0
    @member.user_id = current_user.id
    @member.uuid = UUIDTools::UUID.random_create().to_s
    if @member.save
      redirect_to  viewmember_path(:uuid => @member.uuid) , :notice => t(:created_ok)
    else
      render :new# :back, :alert => t(:unable_to_create)
    end
  end

  
  def select_member
    session[:member_id] = params[:member_id]
    redirect_to products_path, :notice => t(:member_selected_ok)
  end
  
  def cancel_member
    session.delete :member_id
  end
  
  
  protected
  def get_member
    @member = Member.find(params[:id])
  end
  
  
  private
  def members_search(member)
    #if member.phone.nil? && member.name.nil?
    #  nil
    #else
      conditions = {}
      conditions[:name] = member.name unless member.name.nil?
      conditions[:phone] = member.phone unless member.phone.nil?
      search_list = Member.find(:all, :conditions => conditions)
      search_list.count == 0 ? nil : search_list
    #end
    
  end
  
  
end
