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
        if @inventory.inventory_details.count == 0
          redirect_to [:stocker, @inventory], alert: t(:none_of_change_quantity)
        else
          redirect_to [:stocker, @inventory], notice: t(:import_inventory_successfully)
        end
      else
        render :back, :alert => t(:import_failed)
      end 
    else
      render :new
    end
    
    
  end
end
