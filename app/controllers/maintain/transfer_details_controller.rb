class Maintain::TransferDetailsController < ApplicationController
  def index
  end

  def new
    @transfer = Transfer.find(params[:transfer_id])
    @stocks = Stock.where(:store_id => @transfer.from_store_id)
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
