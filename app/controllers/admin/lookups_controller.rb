class Admin::LookupsController < ApplicationController
  def index
    @lookups = Lookup.all
  end
  
  def show
    @lookup = Lookup.find(params[:id])
  end

  def new
    @lookup = Lookup.new
  end

  def create
    @lookup = Lookup.new(params[:lookup])
    @lookup.sequence = '1'
    @lookup.status = '1'
    if @lookup.save
      redirect_to maintain_lookups_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @lookup = Lookup.find(params[:id])
  end

  def update
    @lookup = Lookup.find(params[:id])
    if @lookup.update_attributes(params[:lookup])
      redirect_to maintain_lookup_path(@lookup), :notice => t(:updated_ok)
    else
      redirect_to maintain_lookup_path(@lookup), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
end
