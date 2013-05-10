class TransfersController < ApplicationController
  
  before_filter :require_user
  before_filter :get_transfer, :only => [:show, :edit, :update] 
  before_filter :require_owner, :only => [:show, :edit, :update]
  
  def index
    @transfers = Transfer.where(" to_store_id = :to_store_id and status > 0 and status < 9 ", {:to_store_id => current_user.store_id} ).paginate(:page => params[:page], :per_page => 5).order('id DESC')
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
  
  protected
  def get_transfer
    @transfer = Transfer.find(params[:id])
  end
end

