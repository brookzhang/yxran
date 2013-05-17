class Maintain::MemberImportsController < Maintain::ApplicationController
  def new
    @member_import = MemberImport.new
  end

  def create
    @member_import = MemberImport.new(params[:member_import])
    if @member_import.valid?
      if @member_import.import(current_user.id)
        redirect_to maintain_members_path, notice: t(:import_members_successfully)
      else
        render :back, :alert => t(:import_failed)
      end 
    else
      render :new
    end
    
    
  end
end
