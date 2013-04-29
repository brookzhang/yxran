class Maintain::StoresController < Maintain::ApplicationController
  def index
    @stores = Store.all
  end
  
  def show
    @store = Store.find(params[:id])
    @stocks = Stock.where(" store_id =? ", @store.id)
    @addition = params[:addition].nil? ? 'stock' : params[:addition]
    @user = User.where(:store_id => @store.id).first
    
    case @addition
    when 'sale'
      @sales = Sale.where(:store_id => @store.id).limit(10)
    when 'expense'
      @expenses = Expense.where(:store_id => @store.id).limit(10)
    when 'handover'
      @handovers = Handover.where(:store_id => @store.id).includes(:user).limit(10)
    else
      @stocks = Stock.where(" quantity > 0 and store_id = ? ", @store.id )
    end
    
  end

end
