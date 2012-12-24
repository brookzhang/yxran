class Maintain::OrdersController < ApplicationController
  
  def index
    @product = params[:product_id].nil? ? nil : Category.find(params[:product_id])
    @orders = orders_list(@product)
  end
  
  def show
    @order = Order.find(params[:id])
  end

  def new
    @stores = Store.all
    if params[:product_id].nil?
      redirect_to maintain_products_path, :notice => t(:select_product_first)
    else
      @order = Order.new
      @order.product_id = params[:product_id]
    end
  end

  def create
    @order = Order.new(params[:order])
    @order.status = '1'
    @order.user_id = current_user.id
    
    
    if @order.order_add
      redirect_to maintain_orders_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    #redirect_to maintain_order_path(@order), :notice => @order.order_edit(params[:order][:quantity].to_i).to_s
    if @order.order_edit(params[:order][:quantity].to_i)
      redirect_to maintain_order_path(@order), :notice => t(:updated_ok)
    else
      redirect_to maintain_order_path(@order), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
  
  
  def orders_list(product)
    conditions = {}
    conditions[:product_id] = product.id unless product.nil?
    Order.find(:all, :conditions => conditions)
  end
end
