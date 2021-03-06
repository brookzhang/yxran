class HandoversController < ApplicationController
  
  before_filter :require_user
  before_filter :get_handover, :only => [:show, :edit, :update] 
  before_filter :require_owner, :only => [:show, :edit, :update]
  
  def index
    @handovers = Handover.where(:user_id => current_user.id).paginate(:page => params[:page]).order('id DESC')
    @handover = @handovers.count > 0 ? @handovers.first : Handover.new
  end
  
  def show
    @handover = Handover.find(params[:id])
    @store = Store.find(@handover.store_id)
    @sales = Sale.where(:store_id => @handover.store_id,
                        :user_id => @handover.user_id,
                        :status => 1,
                        :created_at => (@handover.took_at)..(@handover.handed_at.nil? ? Time.now : @handover.handed_at)
                       )
    
    @expenses = Expense.where(:store_id => @handover.store_id,
                        :user_id => @handover.user_id,
                        :status => 1,
                        :created_at => (@handover.took_at)..(@handover.handed_at.nil? ? Time.now : @handover.handed_at)
                        )
    
    
    @sale_amount = @sales.sum{|s| s.actual_amount}
    @expense_amount = @expenses.sum{|e| e.amount}
                        
  end
  
  def new
    @stores = Store.authorized_stores(current_user.id, 'user').where(" not exists(select * from users where store_id = stores.id) ")
    @handover = Handover.new()
    
  end

  def create
    
    @handover = Handover.new(params[:handover])
    @store = Store.find(@handover.store_id)
    
    @handover.user_id = current_user.id
    @handover.take_amount = @store.balance
    @handover.took_at = Time.now
    @handover.status = 0
    if !is_ok_to_take_over?(@handover)
      redirect_to :back 
    else
      
      #logger.error "****************************2#{@handover.user_id}"  
      
      if @handover.save
        current_user.store_id = @handover.store_id
        session[:cart_count] = Cart.count_by_user(current_user).to_s
        redirect_to handovers_path, :notice => t(:you_took_over_ok)
      else
        redirect_to handovers_path, :alert => t(:you_can_not_take_over)
      end
        
    end
    
    
  end
  
  
  def edit
    @handover = Handover.find(params[:id])
    @store = Store.find(@handover.store_id)
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
  
  def update
    @handover = Handover.find(params[:id])
    @store = Store.find(@handover.store_id)
    @handover.hand_remark = params[:handover][:hand_remark]
    @handover.hand_amount = @store.balance
    @handover.handed_at = Time.now
    @handover.status = 1
    #@handover.save
    
    if @handover.save
      current_user.store_id = nil
      session[:cart_count] = 0
      redirect_to handovers_path, :notice => t(:you_handed_over_ok)
    else
      redirect_to handovers_path, :alert => t(:you_can_not_hand_over)
    end
    
  end
  
  
  
  protected
  def get_handover
    @handover = Handover.find(params[:id])
  end
  
  
  
  private
  
  def have_product_in_cart?
    Cart.count_by_user(current_user) > 0
  end
  
  def is_ok_to_take_over?(handover)
    is_ok = true
    
    if !current_user.store_id.nil?
      flash[:alert] = t(:you_have_took_over_a_store)
      is_ok = false
    end
    
    if User.where(:store_id => handover.store_id).count > 0
      flash[:alert] = t(:this_store_not_handed_over)
      is_ok = false
    end
    
    if StoreUser.where(:store_id => handover.store_id, :user_id =>current_user.id, :role => 'user' ).count == 0
      flash[:alert] = t(:you_do_not_have_authority_on_this_store)
      is_ok = false
    end
    
    
    is_ok
  end

end
