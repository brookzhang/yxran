class Maintain::OrderImportsController < Maintain::ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @order_import = OrderImport.new
  end

  def create
    @order = Order.find(params[:order_id])
    @order_import = OrderImport.new(params[:order_import])
    if @order_import.valid?
      if @order_import.save(@order)
        redirect_to [:maintain, @order], notice: t(:import_order_successfully)
      else
        render :back, :alert => t(:import_failed)
      end 
    else
      render :new
    end
    
    
  end
end
