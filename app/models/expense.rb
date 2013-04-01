class Expense < ActiveRecord::Base
  attr_accessible :amount, :category, :remark, :store_id, :user_id
end
