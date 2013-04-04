class Maintain::StoresController < ApplicationController
  def index
    @stores = Store.all
  end
  
  def show
    @store = Store.find(params[:id])
    @stocks = Stock.where(" store_id =? ", @store.id)
  end

end
