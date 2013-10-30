class Stocker::InventoriesController < Stocker::ApplicationController
  before_filter :get_inventory, :only => [:show, :edit, :update, :cancel] 
  before_filter :require_owner, :only => [:edit, :update, :cancel]
  
  def index
    @inventories = Inventory.where(:user_id => current_user.id).paginate(:page => params[:page]).order("id desc")
  end
  
  def show
    @inventory = Inventory.find(params[:id])

    @addition = params[:addition].blank? ? 'details' : params[:addition]
    case @addition
    when 'sales'
      @sales = Sale.where(:store_id => @inventory.store_id).where("created_at > ? and created_at < ?",@inventory.last_inventory_from, @inventory.created_at  ).includes(:user)
    when 'expenses'
      @expenses = Expense.where(:store_id => @inventory.store_id).where("created_at > ? and created_at < ?",@inventory.last_inventory_from, @inventory.created_at  ).includes(:user)
    when 'transfers_out'
      @transfer_details = TransferDetail.joins(:transfer).joins(" users on transfers.user_id = users.id ").where(:transfer => {:from_store_id => @inventory.store_id}).where(" transfers.transfered_at > ? and transfers.transfered_at < ? ", @inventory.last_inventory_from, @inventory.created_at )
    when 'transfers_in'
      @transfer_details = TransferDetail.joins(:transfer).joins(" users on transfers.user_id = users.id ").where(:transfer => {:to_store_id => @inventory.store_id}).where(" transfers.received_at > ? and transfers.transfered_at < ? ", @inventory.last_inventory_from, @inventory.created_at )
    when 'orders'
      @order_details = OrderDetail.joins(:order).where(:order => {:store_id => @inventory.store_id}).where(" orders.created_at > ? and orders.created_at < ? ", @inventory.last_inventory_from, @inventory.created_at )
    else
      @inventory_details = InventoryDetail.where(:inventory_id => @inventory.id).order("product_id asc")
    end


  end

  def new
    @inventory = Inventory.new
    #@stores = Store.where(:category => 'S')
    @stores = Store.authorized_stores(current_user.id, 'stocker').where(:category => 'I')
  end

  def create
    @inventory = Inventory.new(params[:inventory])
    @inventory.status = 0
    @inventory.user_id = current_user.id
    
    if @inventory.save
      redirect_to [:stocker, @inventory], :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end



  def edit
    @inventory = Inventory.find(params[:id])
  end



  def update
    @inventory = Inventory.find(params[:id])
    @inventory.update_attributes(params[:inventory])
    redirect_to stocker_inventory_path(@inventory)
  end




  def destroy
    @inventory = Inventory.find(params[:id])
    if @inventory.status == 0
      if @inventory.destroy
        redirect_to stocker_inventories_path, :notice => t(:deleted_ok)
      else
        redirect_to :back, :alert => t(:unable_to_delete)
      end
    else
      redirect_to :back, :alert => t(:already_confirmed_can_not_delete)
    end
    
  end
  
  def clear
    @inventory = Inventory.find(params[:id])
    if @inventory.status == 0
      if @inventory.inventory_details.destroy_all
        redirect_to stocker_inventory_path(@inventory), :notice => t(:cleared_ok)
      else
        redirect_to :back, :alert => t(:unable_to_clear)
      end
    else
      redirect_to :back, :alert => t(:already_confirmed_can_not_clear)
    end
  end
  
  
  def confirm
    @inventory = Inventory.find(params[:id])
    if @inventory.inventory_details.count > 0 && @inventory.inventory_confirm
      redirect_to stocker_inventory_path(@inventory), :notice => t(:inventory_confirmed_ok)
    else
      redirect_to stocker_inventory_path(@inventory), :alert => t(:unable_to_confirm)
    end
    
  end
  
  
  
  def cancel
    @inventory = Inventory.find(params[:id])
    if @inventory.cancel
      redirect_to stocker_inventories_path, :notice => t(:inventory_canceled_ok)
    else
      redirect_to :back, :alert => t(@inventory.check_message)
    end
  end
  
  
  
  protected
  def get_inventory
    @inventory = Inventory.find(params[:id])
  end
end
