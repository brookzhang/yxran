class AddDutyPeriodLimitToUser < ActiveRecord::Migration
  def up
    add_column :users, :from_time, :string
    add_column :users, :to_time, :string
  end

  def down
    remove_column :users, :from_time
    remove_column :users, :to_time
  end
end
