class Maintain::TransfersController < Maintain::ApplicationController
  def index
    @transfers = Transfer.paginate(:page => params[:page]).order("id desc")
  end
  
  def show
    @transfer = Transfer.find(params[:id])
    @transfer_details = TransferDetail.where(:transfer_id => @transfer.id)
  end

  def cancel
    @transfer = Transfer.find(params[:id])
    if @transfer.cancel_by_manager
      redirect_to maintain_transfers_path, :notice => t(:cancel_ok)
    else
      redirect_to maintain_transfers_path, :alert => t(:unable_to_cancel)
    end

  end

  
end
