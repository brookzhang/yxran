class Stocker::OrderDetailsController < Stocker::ApplicationController
  
  
  
  def new
    @order = Order.find(params[:order_id])
    @order_detail = OrderDetail.new
    
    @product = Product.new(params[:product])
    @product.category_id ||= 0
    @product.super_category_id ||= 0
    @product.id = params[:product].blank? ? 0 : params[:product][:id].blank? ? 0 : params[:product][:id]
    
    
    @array_super = Category.where(:parent_id => 0).map{|c|[c.name,c.id]}
    @array_super.insert(0, [t(:super_category), 0])
    
    @array_sub = []
    @array_sub = Category.where(:parent_id => @product.super_category_id).map{|c|[c.name,c.id]} if @product.super_category_id.to_i > 0
    @array_sub.insert(0, [t(:category), 0])
    
    @array_products = []
    @array_products = Product.in_category(@product.category_id).map{|p| [p.name, p.id]} if @product.category_id.to_i > 0 && @product.id.to_i == 0
    @search_product = Product.find(@product.id) if @product.id.to_i > 0
    @array_products.insert(0,[@search_product.name, @search_product.id.to_s]) if @search_product
    @array_products.insert(0,[t(:all_products), 0])
    
    
    @products = Product.by_category(@product.super_category_id, @product.category_id).paginate(:page => params[:page], :per_page => 5) if @product.id.to_i == 0
    @products = Product.where(:id => @product.id).paginate(:page => params[:page], :per_page => 5) if @product.id.to_i > 0
    
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
