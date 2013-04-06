class Maintain::HandoversController < ApplicationController
  def index
    @handovers = Handover.includes(:user).order(" id desc ")
  end

  def show
    @handover = Handover.find(params[:id])
    @store = Store.find(@handover.store_id)
    @user = User.find(@store.id)
    @sales = Sale.where(:store_id => @handover.store_id,
                        :user_id => @handover.user_id,
                        :created_at => (@handover.took_at)..(@handover.handed_at.nil? ? Time.now : @handover.handed_at)
                       )
    
    @expenses = Expense.where(:store_id => @handover.store_id,
                        :user_id => @handover.user_id,
                        :created_at => (@handover.took_at)..(@handover.handed_at.nil? ? Time.now : @handover.handed_at)
                        )
    
    
    @sale_amount = @sales.sum{|s| s.actual_amount}
    @expense_amount = @expenses.sum{|e| e.amount}
  end
end
