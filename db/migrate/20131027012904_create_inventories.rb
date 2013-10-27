class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
    	t.references :store
    	t.references :user
      t.references :sale
    	t.string :remark
    	t.float :sum_amount
    	t.float :pay_amount
    	t.integer :status, :default => 0

      t.timestamps
    end
    add_index :inventories, :store_id
    add_index :inventories, :user_id
    add_index :inventories, :sale_id

    create_table :inventory_details do |t|
    	t.references :inventory
    	t.references :product
      t.references :sale_detail
      t.integer :stock_quantity
      t.integer :check_quantity
      t.integer :change_quantity
      t.float :unit_price   #unit price offen changes, record as a history
      t.float :amount
      t.integer :status, :default => 0 # 0-cancel

      t.timestamps
    end
    add_index :inventory_details, :inventory_id
    add_index :inventory_details, :product_id
    add_index :inventory_details, :sale_detail_id


  end
end
