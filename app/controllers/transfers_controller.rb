class TransfersController < ApplicationController
  
  before_filter :require_user
  before_filter :get_transfer, :only => [:edit, :update, :destroy, :transfer, :receive] 
  before_filter :require_owner, :only => [:edit, :update, :destroy, :transfer]
  before_filter :require_receiver, :only => [:receive]
  
  def index
    @transfers = Transfer.where(" (to_store_id = :to_store_id or transferer_id = :user_id) and status >= 0 and status < 9 ", {:to_store_id => current_user.store_id, :user_id => current_user.id} ).paginate(:page => params[:page], :per_page => 5).order('id DESC')
  end

  def show
    @transfer = Transfer.find(params[:id])
    @transfer_details = TransferDetail.where(:transfer_id => @transfer.id)
  end

  def new
    @transfer = Transfer.new
    @transfer.from_store_id = current_user.store_id
    @stores = Store.where(" id != ?", @transfer.from_store_id)
  end

  def create
    @transfer = Transfer.new(params[:transfer])
    @transfer.status = 0
    @transfer.transferer_id = current_user.id
    @transfer.from_store_id = current_user.store_id
    
    if @transfer.from_store_id == @transfer.to_store_id
      redirect_to :back, :notice => t(:from_to_store_must_diffrent)
    else
      if @transfer.save
        redirect_to new_transfer_transfer_detail_path(@transfer), :notice => t(:created_ok)
      else
        redirect_to :back, :alert => t(:unable_to_create)
      end
    end
    
  end

  def edit
    @transfer = Transfer.find(params[:id])
    @stores = Store.where(" id != ?", @transfer.from_store_id)
  end
  
  
  def update
    @transfer = Transfer.find(params[:id])
    @transfer.update_attributes(params[:transfer])
    redirect_to transfer_path(@transfer)
  end
  

  def destroy
    @transfer = Transfer.find(params[:id])
    if @transfer.status == 0
      if @transfer.destroy
        redirect_to transfers_path, :notice => t(:deleted_ok)
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
        redirect_to transfer_path(@transfer), :notice => t(:transfered_out_ok)
      else
        redirect_to transfer_path(@transfer), :alert => t(:unable_to_transfer_out)
      end
    else
      redirect_to :back, :alert => t(:not_enough_stock_to_transfer)
    end
    
  end
  

  def receive
    @transfer = Transfer.find(params[:id])
    #@transfer.receive_remark = params[:transfer][:receive_remark]
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
  
  def require_receiver
    @transfer.is_receiver?(current_user)
  end
end

