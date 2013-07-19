class Maintain::LookupsController < Maintain::ApplicationController
  before_filter :need_category, :except => :list

  def list

  end

  def index
    
    @lookups = Lookup.where(:category => params[:category]).order(" id desc ")
  end
  
  def show
    @lookup = Lookup.find(params[:id])
  end

  def new
    @lookup = Lookup.new
  end

  def create
    @lookup = Lookup.new(params[:lookup])
    @lookup.category = params[:category]
    @lookup.sequence = '1'
    @lookup.status = '1'
    if @lookup.save
      redirect_to maintain_lookups_path(params[:category]), :notice => t(:created_ok)
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
      redirect_to maintain_lookups_path(params[:category]), :notice => t(:updated_ok)
    else
      redirect_to :back, :alert => t(:unable_to_update)
    end
  end

  def destroy
    @lookup = Lookup.find(params[:id])
    if @lookup.destroy 
      redirect_to maintain_lookups_path(params[:category])
    else
      redirect_to :back
    end
  end


  private 
  def need_category
    redirect_to maintain_settings_path if params[:category].empty?
  end
end
