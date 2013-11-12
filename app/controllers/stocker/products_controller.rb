class Stocker::ProductsController < Stocker::ApplicationController
  def index
    
    @category_id = params[:category_id].blank? ? 0 : params[:category_id].to_i
    
    @products = Product.in_category(@category_id).by_name(params[:keywords]).paginate(:page => params[:page], :per_page => 10) 
    
  end
  
  def show
    @product = Product.find(params[:id])
    @stores = Store.authorized_stores(current_user.id, 'stocker')
    @stocks = Stock.where(:product_id => @product.id, :store_id => @stores.map(&:id))
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
