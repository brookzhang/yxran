class Maintain::TransfersController < ApplicationController
  def index
    @product = params[:product_id].nil? ? nil : Category.find(params[:product_id])
    @transfers = transfers_list(@product)
  end
  
  def show
    @transfer = Transfer.find(params[:id])
  end

  def new
    @stores = Store.all
    if params[:product_id].nil?
      redirect_to maintain_products_path, :notice => t(:select_product_first)
    else
      @transfer = Transfer.new
      @transfer.product_id = params[:product_id]
    end
  end

  def create
    @transfer = Transfer.new(params[:transfer])
    @transfer.status = '1'
    @transfer.user_id = current_user.id
    
    if @transfer.from_store_id == @transfer.to_store_id
      redirect_to :back, :notice => t(:from_to_store_must_diffrent)
    else
      if @transfer.transfer_add
        redirect_to maintain_transfers_path, :notice => t(:created_ok)
      else
        redirect_to :back, :alert => t(:unable_to_create)
      end
    end
    
  end

  def edit
    @transfer = Transfer.find(params[:id])
  end

  def update
    @transfer = Transfer.find(params[:id])
    #redirect_to maintain_transfer_path(@transfer), :notice => @transfer.transfer_edit(params[:transfer][:quantity].to_i).to_s
    if @transfer.transfer_edit(params[:transfer][:quantity].to_i)
      redirect_to maintain_transfer_path(@transfer), :notice => t(:updated_ok)
    else
      redirect_to maintain_transfer_path(@transfer), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
  
  
  def transfers_list(product)
    conditions = {}
    conditions[:product_id] = product.id unless product.nil?
    Transfer.find(:all, :conditions => conditions)
  end
end
