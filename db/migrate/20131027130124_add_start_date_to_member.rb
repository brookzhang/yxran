class AddStartDateToMember < ActiveRecord::Migration
  def change
  	add_column :members, :start_date, :date
  end
end
