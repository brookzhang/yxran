class Admin::SwitchesController < ApplicationController
  def index
    @switchs = Switch.all
  end
  
  def show
    @switch = Switch.find(params[:id])
  end

  def new
    @switch = Switch.new
  end

  def create
    @switch = Switch.new(params[:switch])
    @switch.status = '1'
    if @switch.save
      redirect_to maintain_switchs_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @switch = Switch.find(params[:id])
  end

  def update
    @switch = Switch.find(params[:id])
    if @switch.update_attributes(params[:switch])
      redirect_to maintain_switch_path(@switch), :notice => t(:updated_ok)
    else
      redirect_to maintain_switch_path(@switch), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
  
  
end
