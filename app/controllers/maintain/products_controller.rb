class Maintain::ProductsController < ApplicationController
  def index
    @category = params[:category_id].nil? ? nil : Category.find(params[:category_id])
    @products = products_list(@category)
  end
  
  def show
    @product = Product.find(params[:id])
    @stocks = Stock.where(" product_id =? ", @product.id)
    @categories = Category.where(:parent_id => @product.category.parent_id)
  end

  def new
    if params[:category_id].nil?
      redirect_to maintain_categories_path, :notice => t(:select_category_first)
    else
      @product = Product.new
      @product.category_id = params[:category_id]
    end
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to maintain_products_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to maintain_product_path(@product), :notice => t(:updated_ok)
    else
      redirect_to maintain_product_path(@product), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
  
  
  def products_list(category)
    conditions = {}
    conditions[:category_id] = category.id unless category.nil?
    Product.find(:all, :conditions => conditions)
  end
  
end
