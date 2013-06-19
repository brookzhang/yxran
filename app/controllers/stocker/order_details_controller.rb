class Stocker::OrderDetailsController < Stocker::ApplicationController
  
  
  
  def new
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new
    
    @product = Product.new(params[:product])
    category_id = @product.category_id.nil? ? 0 : @product.category_id
    category_id = category_id == 0 ? (@product.super_category_id.nil? ? 0 : @product.super_category_id) : category_id
    
    @products = Product.in_category(category_id).by_name(@product.name).paginate(:page => params[:page], :per_page => 5).order(" id desc ")
    
    @array_super = Category.where(:parent_id => 0).map{|c|[c.name,c.id]}.insert(0, t(:super_category))
    @array_sub = @product.super_category_id.nil? && @product.super_category_id == 0 ? [] : Category.where(:parent_id => @product.super_category_id).map{|c|[c.name,c.id]}
    @array_sub.insert(0, t(:category))
  end
  
  

  def create
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new(params[:order_detail])
    @order_detail.order_id = @order.id
    if @order_detail.save
      redirect_to :back, :notice => t(:add_to_order_ok)
    else
      redirect_to :back, :alert => t(:add_failed) + @order_detail.errors.first.to_s
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
