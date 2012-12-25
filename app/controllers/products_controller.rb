class ProductsController < ApplicationController
  def index
    @category = params[:category_id].nil? ? nil : Category.find(params[:category_id])
    @products = products_list(@category)
  end
  
  def show
    @product = Product.find(params[:id])
    @stocks = Stock.where(" product_id =? ", @product.id)
  end
  
  
  def products_list(category)
    conditions = {}
    conditions[:category_id] = category.id unless category.nil?
    Product.find(:all, :conditions => conditions)
  end
end
