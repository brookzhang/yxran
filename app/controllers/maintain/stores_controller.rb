class Maintain::StoresController < Maintain::ApplicationController
  def index
    @stores = Store.paginate(:page => params[:page], :per_page => 10).order('id DESC')
  end
  
  def show
    @store = Store.find(params[:id])
    @addition = params[:addition].nil? ? 'stock' : params[:addition]
    @user = User.where(:store_id => @store.id).first
    
    case @addition
    when 'sale'
      @sales = Sale.where(:store_id => @store.id).limit(10)
    when 'expense'
      @expenses = Expense.where(:store_id => @store.id).limit(10)
    when 'handover'
      @handovers = Handover.where(:store_id => @store.id).includes(:user).limit(10)
    when 'store_user'
      @store_users = StoreUser.where(:store_id => @store.id)
    else
      @stocks = Stock.where(" quantity > 0 and store_id = ? ", @store.id ).limit(5)
    end
    
  end
  
  def new
    @lookups = Lookup.where(" category = ? ", "store_category")
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to maintain_stores_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @lookups = Lookup.where(" category = ? ", "store_category")
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      redirect_to maintain_store_path(@store), :notice => t(:updated_ok)
    else
      redirect_to maintain_store_path(@store), :alert => t(:unable_to_update)
    end
  end

end
