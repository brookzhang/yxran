class Maintain::ProductsController < ApplicationController
  def index
    @products = Product.all
  end
  
  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
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
end
