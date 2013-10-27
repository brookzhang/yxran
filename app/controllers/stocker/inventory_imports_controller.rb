class Stocker::InventoryImportsController < Stocker::ApplicationController
  def new
    @inventory = Inventory.find(params[:inventory_id])
    @inventory_import = InventoryImport.new
  end

  def create
    @inventory = Inventory.find(params[:inventory_id])
    @inventory_import = InventoryImport.new(params[:inventory_import])
    if @inventory_import.valid?
      if @inventory_import.save(@inventory)
        redirect_to [:stocker, @inventory], notice: t(:import_inventory_successfully)
      else
        render :back, :alert => t(:import_failed)
      end 
    else
      render :new
    end
    
    
  end
end
