class Maintain::MembersController < Maintain::ApplicationController
  def index
    @members = Member.paginate(:page => params[:page]).order("id desc")
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
      render :edit
    end
  end
  
  def destroy
    @member = Member.find(params[:id])
    if @member.is_ok_to_destroy?
      if @member.destroy
        redirect_to maintain_members_path, :notice => t(:deleted_ok)
      else
        render :show
      end
    else
      redirect_to :back, :alert => t(:member_has_sales_or_scores_can_not_delete)
    end
    
    
  end
  
end
