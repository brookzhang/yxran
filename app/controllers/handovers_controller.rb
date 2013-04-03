class HandoversController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @handovers = Handover.where(:user_id => current_user.id).order(" id desc ")
    @handover = @handovers.count > 0 ? @handovers..first : Handover.new
  end
  
  def new
    @stores = Store.where(" not exists(select * from users where store_id = stores.id) ")
    @handover = Handover.new()
    
  end

  def create
    
    @handover = Handover.new(params[:handover])
    if !is_ok_to_take_over(@handover)
      redirect_to :back, :alert => t(:you_can_not_take_over)
    else
      @handover.category = 'T' #take over
      @handover.store_id = current_user.store_id
      @handover.take_amount = current_user.store.balance
      @handover.take_amount = current_user.store.balance
      @handover.took_at = Time.now
      @handover.save
    end
    
    
  end
  
  
  def edit
    @handover = Handover.find(params[:id])
  end
  
  def update
    
  end
  
  
  
  
  private
  
  def have_product_in_cart?
    Cart.count_by_user(current_user) > 0
  end
  
  def is_ok_to_take_over?(handover)
    
    
  end

end
