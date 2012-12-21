class MembersController < ApplicationController
  def index
    @member = Member.new
    @member.name = params[:name]
    @member.phone = params[:phone]
    
    @members = members_search(@member)
  end

  def show
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
      redirect_to membersale_path(:member_id => @member), :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
  end

  def edit
  end

  def update
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
