class Stocker::TransfersController < Stocker::ApplicationController
  def index
    @transfers = Transfer.paginate(:page => params[:page]).order("id desc")
  end
  
  def show
    @transfer = Transfer.find(params[:id])
    @transfer_details = TransferDetail.where(:transfer_id => @transfer.id)
  end

  def new
    @transfer = Transfer.new
    @stores = Store.all
  end

  def create
    @transfer = Transfer.new(params[:transfer])
    @transfer.status = 0
    @transfer.transferer_id = current_user.id
    
    if @transfer.from_store_id == @transfer.to_store_id
      redirect_to :back, :notice => t(:from_to_store_must_diffrent)
    else
      if @transfer.save
        redirect_to new_stocker_transfer_transfer_detail_path(@transfer), :notice => t(:created_ok)
      else
        redirect_to :back, :alert => t(:unable_to_create)
      end
    end
    
  end



  def edit
    @transfer = Transfer.find(params[:id])
    @stores = Store.all
  end



  def update
    @transfer = Transfer.find(params[:id])
    @transfer.update_attributes(params[:transfer])
    redirect_to stocker_transfer_path(@transfer)
  end




  def destroy
    @transfer = Transfer.find(params[:id])
    if @transfer.status == 0
      if @transfer.destroy
        redirect_to stocker_transfers_path, :notice => t(:deleted_ok)
      else
        redirect_to :back, :alert => t(:unable_to_delete)
      end
    else
      redirect_to :back, :alert => t(:already_transfered_can_not_delete)
    end
    
  end
  
  
  
  
  
  
  def transfer
    @transfer = Transfer.find(params[:id])
    if @transfer.is_ok_to_transfer?
      if @transfer.transfer
        redirect_to stocker_transfer_path(@transfer), :notice => t(:transfered_out_ok)
      else
        redirect_to stocker_transfer_path(@transfer), :alert => t(:unable_to_transfer_out)
      end
    else
      redirect_to :back, :alert => t(:not_enough_stock_to_transfer)
    end
    
  end
  
  
end
