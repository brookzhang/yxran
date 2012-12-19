class AddLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :store_id, :integer
  end
end
