class Stocker::OrdersController < Stocker::ApplicationController
  
  before_filter :get_order, :only => [:show, :edit, :update, :cancel] 
  before_filter :require_owner, :only => [:edit, :update, :cancel]
  
  def index
    @orders = Order.paginate(:page => params[:page]).order("id desc")
  end
  
  def show
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(:order_id => @order.id).order("product_id asc")
  end

  def new
    @order = Order.new
    #@stores = Store.where(:category => 'S')
    @stores = Store.authorized_stores(current_user.id, 'stocker')
  end

  def create
    @order = Order.new(params[:order])
    @order.status = 0
    @order.user_id = current_user.id
    
    if @order.save
      redirect_to [:stocker, @order], :notice => t(:created_ok)
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
    redirect_to stocker_order_path(@order)
  end




  def destroy
    @order = Order.find(params[:id])
    if @order.status == 0
      if @order.destroy
        redirect_to stocker_orders_path, :notice => t(:deleted_ok)
      else
        redirect_to :back, :alert => t(:unable_to_delete)
      end
    else
      redirect_to :back, :alert => t(:already_ordered_can_not_delete)
    end
    
  end
  
  
  
  
  def confirm
    @order = Order.find(params[:id])
    if @order.order_confirm
      redirect_to stocker_order_path(@order), :notice => t(:order_confirmed_ok)
    else
      redirect_to stocker_order_path(@order), :alert => t(:unable_to_order_out)
    end
    
  end
  
  
  
  def cancel
    @order = Order.find(params[:id])
    if @order.cancel
      redirect_to stocker_orders_path, :notice => t(:order_canceled_ok)
    else
      redirect_to :back, :alert => t(@order.check_message)
    end
  end
  
  
  
  protected
  def get_order
    @order = Order.find(params[:id])
  end
  
end
