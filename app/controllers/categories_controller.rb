class CategoriesController < ApplicationController
  
  
  def refresh_sub
    parent_id =  (params[:parent_id].nil? || params[:parent_id].empty?) ? 0 : params[:parent_id].to_i
    
    if parent_id == 0
      @categories = [].insert(0, t(:category))
    else
      @categories = Category.where(:parent_id => parent_id).map{|c| [c.name, c.id]}.insert(0, t(:category))
    end
    
  end
  
end
