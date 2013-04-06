class Maintain::ExpensesController < ApplicationController
  def index
    @expenses = Expense.order(" id desc ")
  end

  def show
  end
end
