class Maintain::MembersController < Maintain::ApplicationController
  def index
    @members = Member.all
  end
  
  def show
    @member = Member.find(params[:id])
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member])
      redirect_to maintain_member_path(@member), :notice => t(:updated_ok)
    else
      redirect_to maintain_member_path(@member), :alert => t(:unable_to_update)
    end
  end
  
end
