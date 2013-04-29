class TransfersController < ApplicationController
  def index
    @transfers = Transfer.where(" to_store_id = :to_store_id and status > 0 and status < 9 ", {:to_store_id => current_user.store_id} )
  end

  def show
    @transfer = Transfer.find(params[:id])
    @transfer_details = TransferDetail.where(:transfer_id => @transfer.id)
  end

  def edit
    @transfer = Transfer.find(params[:id])
    @transfer_details = TransferDetail.where(:transfer_id => @transfer.id)
  end

  def update
    @transfer = Transfer.find(params[:id])
    @transfer.receive_remark = params[:transfer][:receive_remark]
    @transfer.receiver_id = current_user.id
    if @transfer.receive
      redirect_to @transfer, :notice => t(:received_ok)
    else
      redirect_to :back, :alert => t(:received_failed)
    end
    
  end
end

