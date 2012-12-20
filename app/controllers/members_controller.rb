class MembersController < ApplicationController
  def index
    @member = Member.new
    @member.name = params[:name]
    @member.phone = params[:phone]
    
    @members = members_search(@member)
  end

  def show
  end

  def create
  end

  def edit
  end

  def update
  end
  
  
  
  
  private
  def members_search(member)
    if member. name.nil? && member.phone.nil?
      nil
    else
      conditions = {}
      conditions[:name] = member.name unless member.name.nil?
      conditions[:phone] = member.phone unless member.phone.nil?
      search_list = Member.find(:all, :conditions => conditions)
      search_list.count == 0 ? nil : search_list
    end
    
  end
end
