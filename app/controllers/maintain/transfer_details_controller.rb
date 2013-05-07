class Maintain::TransferDetailsController < Maintain::ApplicationController


  def new
    @transfer = Transfer.find(params[:transfer_id])
    @stocks = Stock.where(" store_id = ? and quantity > 0 ", @transfer.from_store_id).paginate(:page => params[:page])
    @transfer_detail = TransferDetail.new
  end

  def create
    @transfer = Transfer.find(params[:transfer_id])
    params[:product_id].keys.each do |p|
      if params[:product_id][p].to_i > 0
        #need to check errors
        @transfer_detail = TransferDetail.where(:transfer_id => @transfer.id, :product_id => p).first
        if @transfer_detail.nil?
          @transfer_detail = TransferDetail.new(:transfer_id => @transfer.id,
                                                :product_id => p,
                                                :quantity => params[:product_id][p])
        else
          @transfer_detail.quantity += params[:product_id][p].to_i
        end
        @transfer_detail.save!  
      end
    end
    
    redirect_to :back, :notice => t(:add_ok)
    
  end


  def destroy
    @transfer = Transfer.find(params[:transfer_id])
    @transfer_detail = TransferDetail.find(params[:id])
    if @transfer_detail.destroy
      redirect_to [:maintain, @transfer], :notice => t(:deleted_ok)
    else
      redirect_to :back, :alert => t(:unable_to_delete)
    end
  end
  
  
  
end
