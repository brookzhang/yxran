class ExpensesController < ApplicationController
  
  before_filter :require_user
  before_filter :get_expense, :only => [:show, :edit, :update, :cancel] 
  before_filter :require_owner, :only => [:show, :edit, :update, :cancel]
  before_filter :require_handover 
  
  def index
    @expenses = Expense.where(:user_id => current_user.id).paginate(:page => params[:page]).order(" id desc ")
  end

  def show
    @expense = Expense.find(params[:id])
  end

  def new
    @expense = Expense.new(:category => 'O')
    @lookups = Lookup.where(:category => 'expense_category')
  end

  def create
    @lookups = Lookup.where(:category => 'expense_category')
        
    @expense = Expense.new(params[:expense])
    @expense.user_id = current_user.id
    @expense.store_id = current_user.store_id
    if @expense.valid?
      if @expense.create_balance
        redirect_to expenses_path, :notice => t(:new_expense_saved_ok)
      else
        render :new 
      end
    else
      render :new 
    end
    
    
      
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  
  def cancel
    @expense = Expense.find(params[:id])
    if @expense.cancel_by_self
      redirect_to expenses_path, :notice => t(:expense_canceled_ok)
    else
      redirect_to :back, :alert => t(@expense.check_message)
    end
  end
  

  
  protected
  def get_expense
    @expense = Expense.find(params[:id])
  end
end
