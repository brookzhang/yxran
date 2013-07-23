class Stocker::ProductImportsController < Stocker::ApplicationController
  def new
    @product_import = ProductImport.new
  end

  def create
    @product_import = ProductImport.new(params[:product_import])
    if @product_import.valid?
      if @product_import.import
        redirect_to stocker_products_path, notice: t(:import_products_successfully)
      else
        render :new, :alert => t(:import_failed)
      end 
    else
      render :new
    end
    
    
  end
end
