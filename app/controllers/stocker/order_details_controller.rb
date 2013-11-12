class Stocker::OrderDetailsController < Stocker::ApplicationController
  
  
  
  def new
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new

    @category_id = params[:category_id].blank? ? 0 : params[:category_id].to_i
    @products = Product.in_category(@category_id).by_name(params[:keywords]).paginate(:page => params[:page], :per_page => 8)

    
  end
  
  

  def create
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new(params[:order_detail])
    @order_detail.order_id = @order.id
    if @order_detail.save
      redirect_to :back, :notice => t(:add_to_order_ok)
    else
      redirect_to :back, :alert => t(:add_failed) + ':'  + @order_detail.errors.first[1]
    end
    
    
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
