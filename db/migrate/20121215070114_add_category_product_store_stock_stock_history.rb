class AddCategoryProductStoreStockStockHistory < ActiveRecord::Migration
  def change
    
    create_table(:categories) do |t|
      t.integer :parent_id
      t.string :name
      t.string :description
      t.integer :sequence
      t.integer :status, :default => 1
      
      t.timestamps
    end
    
    create_table :measurements do |t|
      t.string :name
      t.string :measurement
      t.integer :unit_count, :default => 1
      
      t.timestamps
    end
    
  
    create_table(:products) do |t|
      t.string :name
      t.references :category
      t.string :description
      #t.string :measurement
      t.float :default_price
      t.references :measurement
      t.string :tag
      t.integer :status, :default => 1
      
      t.timestamps
    end
    
    
    create_table(:stores) do |t|
      t.string :name
      t.string :category  # store type
      t.float :balance, :default => 0
      t.string :remark
      t.integer :status, :default => 1
      
      t.timestamps
    end

    
    create_table(:stocks) do |t|
      t.references :product
      t.references :store
      t.integer :quantity
      t.integer :safe_stock
      t.string :remark
      
      t.timestamps
    end
    
    create_table(:stock_histories) do |t|
      t.references :stock
      t.references :user
      t.string :adjust_type #adjust type
      t.integer :reference_id #sale_id or adjust_id
      t.integer :adjusted_by  # 
      t.integer :adjusted_to
      t.datetime :adjusted_at
      t.string :remark
    end
    
    create_table :product_prices do |t|
      t.references :product
      t.references :store
      t.float :unit_price
    end

    add_index(:products, [:name, :category_id])
    add_index(:products, :tag )
    add_index(:stores, [:name, :category])
    add_index(:stocks, [:product_id, :store_id ])
    add_index(:stock_histories, :stock_id )
    add_index(:stock_histories, :adjust_type )
    add_index :product_prices, [:product_id, :store_id]
  end
end
