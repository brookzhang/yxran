class AddNameLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :store_id, :integer
  end
end
