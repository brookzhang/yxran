class Maintain::TransfersController < Maintain::ApplicationController
  def index
    @transfers = Transfer.paginate(:page => params[:page]).order("id desc")
  end
  
  def show
    @transfer = Transfer.find(params[:id])
    @transfer_details = TransferDetail.where(:transfer_id => @transfer.id)
  end

  
end
