class MembersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @member = Member.new
    @member.name = params[:name]
    @member.phone = params[:phone]
    
    #@members = members_search(@member)
    @members = Member.by_name(params[:name]).by_phone(params[:phone]).paginate(:page => params[:page], :per_page => 5).order('id DESC')
  end

  def show
    @member = Member.find(params[:id])
  end
  
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
    if @member.save
      redirect_to  @member , :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
  end

  def edit
  end

  def update
  end
  
  def select_member
    session[:member_id] = params[:member_id]
    redirect_to products_path, :notice => t(:member_selected_ok)
  end
  
  def cancel_member
    session.delete :member_id
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
