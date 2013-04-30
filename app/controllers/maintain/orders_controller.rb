class Maintain::OrdersController < Maintain::ApplicationController
  
  def index
    @orders = Order.all
  end
  
  def show
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(:order_id => @order.id)
  end

  def new
    @order = Order.new
    @stores = Store.where(:category => 'S')
  end

  def create
    @order = Order.new(params[:order])
    @order.status = 0
    @order.user_id = current_user.id
    
    if @order.save
      redirect_to new_maintain_order_order_detail_path(@order), :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end



  def edit
    @order = Order.find(params[:id])
    @stores = Store.all
  end



  def update
    @order = Order.find(params[:id])
    @order.update_attributes(params[:order])
    redirect_to maintain_order_path(@order)
  end




  def destroy
    @order = Order.find(params[:id])
    if @order.status == 0
      if @order.destroy
        redirect_to maintain_orders_path, :notice => t(:deleted_ok)
      else
        redirect_to :back, :alert => t(:unable_to_delete)
      end
    else
      redirect_to :back, :alert => t(:already_ordered_can_not_delete)
    end
    
  end
  
  
  
  
  
  
  def order
    @order = Order.find(params[:id])
    if @order.is_ok_to_order?
      if @order.order
        redirect_to maintain_order_path(@order), :notice => t(:ordered_out_ok)
      else
        redirect_to maintain_order_path(@order), :alert => t(:unable_to_order_out)
      end
    else
      redirect_to :back, :alert => t(:not_enough_stock_to_order)
    end
    
  end
  
  
end
