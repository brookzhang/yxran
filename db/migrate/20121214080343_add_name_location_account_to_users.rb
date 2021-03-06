class AddNameLocationAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :store_id, :integer
    add_column :users, :status, :integer, :default => 1 #1-active 0-inactive
    add_column :users, :account, :string
  end
end
