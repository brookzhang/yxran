class Maintain::ExpensesController < Maintain::ApplicationController
  def index
    @expenses = Expense.order(" id desc ")
  end

  def show
  end
  
end
