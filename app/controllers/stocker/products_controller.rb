class Stocker::ProductsController < Stocker::ApplicationController
  def index
    
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
  
  def show
    @product = Product.find(params[:id])
    @stocks = Stock.where(" product_id =? ", @product.id)
    @categories = Category.where(:parent_id => @product.category.parent_id)
  end

  def new
    @super_categories = Category.where(:parent_id => 0)
    @categories = [].insert(0, t(:category))
    @product = Product.new
    @measurements = Measurement.order(" measurement asc, unit_count asc")
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to stocker_products_path, :notice => t(:created_ok)
    else
      render :new, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    
    @product = Product.find(params[:id])
    @product.super_category_id = @product.category.parent_id
    
    @super_categories = Category.where(:parent_id => 0)
    @categories = Category.where(:parent_id => @product.super_category_id)
    @measurements = Measurement.where(:measurement => @product.measurement.measurement)
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to stocker_product_path(@product), :notice => t(:updated_ok)
    else
      redirect_to stocker_product_path(@product), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
  
  
  
  def select_file
    
  end
  
end
