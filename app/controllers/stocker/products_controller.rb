class Stocker::ProductsController < Stocker::ApplicationController
  def index
    
    @product = Product.new(params[:product])
    category_id = @product.category_id.nil? ? 0 : @product.category_id
    category_id = category_id == 0 ? (@product.super_category_id.nil? ? 0 : @product.super_category_id) : category_id
    
    @products = Product.in_category(category_id).by_name(@product.name).paginate(:page => params[:page], :per_page => 5).order(" id desc ")
    
    @array_super = Category.where(:parent_id => 0).map{|c|[c.name,c.id]}.insert(0, t(:super_category))
    @array_sub = @product.super_category_id.nil? && @product.super_category_id == 0 ? [] : Category.where(:parent_id => @product.super_category_id).map{|c|[c.name,c.id]}
    @array_sub.insert(0, t(:category))
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
