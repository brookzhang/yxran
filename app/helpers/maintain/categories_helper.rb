module Maintain::CategoriesHelper
  
  def discounts_list(category_id)
    result = ""
    @discounts = Discount.order(" member_level asc ").where(" category_id = ? ", category_id)
    @discounts.each do |discount|
      result << l(discount.member_level.to_s, "member_level") << "*" << discount.discount.to_s << ",   " 
    end
    
    result
  end
end
