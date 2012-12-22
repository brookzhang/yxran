class Maintain::CategoriesController < ApplicationController
  def index
    @parent_category = params[:parent_id].nil? ? nil : Category.find(params[:parent_id])
    @categories = categories_list(@parent_category)
  end
  
  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
    @category.parent_id = params[:parent_id].nil? ? 0 : params[:parent_id]
  end

  def create
    @category = Category.new(params[:category])
    @category.sequence = '1'
    @category.status = '1'
    if @category.save
      redirect_to maintain_categories_path, :notice => t(:created_ok)
    else
      redirect_to :back, :alert => t(:unable_to_create)
    end
    
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to maintain_category_path(@category), :notice => t(:updated_ok)
    else
      redirect_to maintain_category_path(@category), :alert => t(:unable_to_update)
    end
  end

  def destroy
  end
  
  
  
  private
  def categories_list(parent_category)
    conditions = {}
    conditions[:parent_id] = parent_category.nil? ? 0 : parent_category.id
    Category.find(:all, :conditions => conditions)
  end
  
end
