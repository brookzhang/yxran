class Maintain::OrdersController < Maintain::ApplicationController
  
  def index
    @orders = Order.paginate(:page => params[:page]).order("id desc")
  end
  
  def show
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(:order_id => @order.id).order("product_id asc")
  end




  
  
end
