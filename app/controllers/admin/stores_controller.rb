class Admin::StoresController < Admin::ApplicationController
  def index
    @stores = Store.all
  end
  
  def show
    @store = Store.find(params[:id])
  end

  def new
    @lookups = Lookup.where(" category = ? ", "store")
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to admin_stores_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @lookups = Lookup.where(" category = ? ", "store")
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      redirect_to admin_store_path(@store), :notice => t(:updated_ok)
    else
      redirect_to admin_store_path(@store), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
end
