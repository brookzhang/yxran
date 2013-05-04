class Maintain::ExpensesController < Maintain::ApplicationController
  def index
    @expenses = Expense.paginate(:page => params[:page]).order(" id desc ")
  end

  def show
  end
  
end
