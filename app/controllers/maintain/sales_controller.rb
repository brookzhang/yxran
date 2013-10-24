class Maintain::SalesController < Maintain::ApplicationController
  def index
    @sales = Sale.includes(:user, :store).paginate(:page => params[:page]).order("id desc")
  end
  
  def show
    @sale = Sale.find(params[:id])
    @sale_details = SaleDetail.where( :sale_id => @sale.id)
    @member = @sale.member_id.nil? ? nil : Member.find(@sale.member_id)
  end


  def cancel
    @sale = Sale.find(params[:id])
    if @sale.cancel_by_manager
      redirect_to maintain_sales_path, :notice => t(:sale_canceled_ok)
    else
      redirect_to :back, :alert => t(@sale.check_message)
    end
  end
  
end
