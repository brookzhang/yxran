class Maintain::DiscountsController < Maintain::ApplicationController
  def index
    #@category = params[:category_id].nil? ? nil : Category.find(params[:category_id])
    #@discounts = discounts_list(@category)
    @discounts = Discount.paginate(:page => params[:page]).order("id desc")
  end
  
  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @lookups = Lookup.where(" category = ? ", "member")
    if params[:category_id].nil?
      redirect_to maintain_categories_path, :notice => t(:select_category_first)
    else
      @discount = Discount.new
      @discount.category_id = params[:category_id]
    end
  end

  def create
    @discount = Discount.new(params[:discount])
    if @discount.save
      redirect_to maintain_discounts_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @lookups = Lookup.where(" category = ? ", "member")
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update_attributes(params[:discount])
      redirect_to maintain_discount_path(@discount), :notice => t(:updated_ok)
    else
      redirect_to maintain_discount_path(@discount), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
  
  
  def discounts_list(category)
    conditions = {}
    conditions[:category_id] = category.id unless category.nil?
    Discount.find(:all, :conditions => conditions)
  end
end
