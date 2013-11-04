class Maintain::ExpensesController < Maintain::ApplicationController
  def index
    @expenses = Expense.paginate(:page => params[:page]).order(" id desc ")
  end

  def show
  end


  def cancel
    @expense = Expense.find(params[:id])
    if @expense.cancel_by_manager
      redirect_to maintain_expenses_path, :notice => t(:expense_canceled_ok)
    else
      redirect_to :back, :alert => t(@expense.check_message)
    end
  end
  

  
  
end
