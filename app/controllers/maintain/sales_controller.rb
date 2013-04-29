class Maintain::SalesController < Maintain::ApplicationController
  def index
    @sales = Sale.includes(:user, :store).order(" id desc ")
  end
  
  def show
    @sale = Sale.find(params[:id])
    @sale_details = SaleDetail.where( :sale_id => @sale.id)
    @member = @sale.member_id.nil? ? nil : Member.find(@sale.member_id)
  end

  def edit
    @sale = Sale.find(params[:id])
  end

  def update
    @sale = Sale.find(params[:id])
    if @sale.update_attributes(params[:sale])
      redirect_to sale_path(@sale), :notice => t(:updated_ok)
    else
      redirect_to sale_path(@sale), :alert => t(:unable_to_update)
    end
  end
  
end
