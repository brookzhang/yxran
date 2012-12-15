class AddLookupProductStoreStockHistory < ActiveRecord::Migration
  def change
    create_table(:lookups) do |t|
      t.string :code
      t.string :category
      t.string :description
      t.integer :sequence
      t.integer :status
      
      t.timestamps
    end
  
    create_table(:products) do |t|
      t.string :name
      t.string :description
      t.string :category  #tea type
      t.string :measurement
      t.float :unit_price
      
      t.timestamps
    end
    
    
    create_table(:stores) do |t|
      t.string :name
      t.string :category  # store type
      t.string :remark
      
      t.timestamps
    end

    
    create_table(:stocks, :id => false) do |t|
      t.references :product
      t.references :store
      t.integer :quantity
      t.integer :safe_stock
      t.string :remark
      
      t.timestamps
    end
    
    create_table(:histories, :id => false) do |t|
      t.references :stock
      t.string :adjust_type #adjust type
      t.integer :reference_id #sale_id or adjust_id
      t.integer :adjusted_by
      t.integer :adjusted_to
      t.datetime :adjusted_at
      t.string :remark
    end

    add_index(:lookups, [:code, :category])
    add_index(:products, [:name, :category])
    add_index(:stores, [:name, :category])
    add_index(:stocks, [:product_id, :store_id ])
    add_index(:histories, [:stock_id, :adjust_type, :adjusted_at ])
  end
end
