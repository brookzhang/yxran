class Stocker::OrderDetailsController < Stocker::ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @products = Product.all
    @order_detail = OrderDetail.new
  end

  def create
    @order = Order.find(params[:order_id])
    params[:product_id].keys.each do |p|
      if params[:product_id][p].to_i > 0
        #need to check errors
        @order_detail = OrderDetail.where(:order_id => @order.id, :product_id => p).first
        if @order_detail.nil?
          @order_detail = OrderDetail.new(:order_id => @order.id,
                                                :product_id => p,
                                                :quantity => params[:product_id][p])
        else
          @order_detail.quantity += params[:product_id][p].to_i
        end
        @order_detail.save!  
      end
    end
    
    redirect_to :back, :notice => t(:add_ok)
    
  end


  def destroy
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.find(params[:id])
    if @order_detail.destroy
      redirect_to [:stocker, @order], :notice => t(:deleted_ok)
    else
      redirect_to :back, :alert => t(:unable_to_delete)
    end
  end
end
