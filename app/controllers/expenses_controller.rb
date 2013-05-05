class ExpensesController < ApplicationController
  
  before_filter :get_expense, :only => [:show, :edit, :update] 
  before_filter :require_owner, :only => [:show, :edit, :update]
  
  def index
    @expenses = Expense.where(:user_id => current_user.id).paginate(:page => params[:page]).order(" id desc ")
  end

  def show
  end

  def new
    @expense = Expense.new
    @lookups = Lookup.where(:category => 'expense_category')
  end

  def create
    @expense = Expense.new(params[:expense])
    @expense.user_id = current_user.id
    @expense.store_id = current_user.store_id
    if @expense.save
      redirect_to expenses_path, :notice => t(:new_expense_saved_ok)
    else
      redirect_to :back, :alert => t(:new_expense_saved_failed)
    end
      
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  protected
  def get_expense
    @expense = Expense.find(params[:id])
  end
end
