class Maintain::ProductsController < Maintain::ApplicationController
  def index
    
    @category_id = params[:category_id].blank? ? 0 : params[:category_id].to_i
    
    @products = Product.in_category(@category_id).paginate(:page => params[:page], :per_page => 10) 
    
  end
  
  def show
    @product = Product.find(params[:id])
    @stocks = Stock.where(" product_id =? ", @product.id)
  end

end
