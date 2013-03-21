class AddMemberSaleTransferOrder < ActiveRecord::Migration
  def change
    create_table(:members) do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :remark    #member remark
      t.integer :level, :default => 0   #member level : 0-normal member, 1-, 2-vip2, vip3
      t.float :score  #buy something ,add score . need a score using history
      t.float :all_score 
      t.references :user  #creator
      
      t.timestamps
    end
  
    create_table(:sales) do |t|
      t.references :store
      t.integer :member_id  #category=M , or is nil
      t.string :category  #sale type M-member buy, N-normal sale, C-cost sale
      t.string :discount_type #D-discount ,S-saved score
      t.integer :quantity
      t.float :amount       #actual amount 
      t.float :score        #if discount_type == D, score = 0
      t.float :used_score
      t.string :remark
      t.integer :status, :default => 1 # 0-cancel
      t.references :user
      
      t.timestamps
    end
    
    create_table(:sale_details) do |t|
      t.references :product
      t.integer :quantity
      t.float :unit_price
      t.float :amount
      t.float :score
      t.string :remark
      t.integer :status, :default => 1 # 0-cancel
      
      t.timestamps
    end
    
    create_table(:transfers) do |t|
      t.integer :from_store_id
      t.integer :to_store_id
      t.references :product
      t.integer :quantity
      t.string :remark
      t.integer :status, :default => 1 # 0-cancel
      t.references :user
      
      t.timestamps
    end

    
    create_table(:orders) do |t|
      t.references :store
      t.references :product
      t.integer :quantity
      t.float :amount
      t.string :remark
      t.integer :status, :default => 1 # 0-cancel
      t.references :user
      
      t.timestamps
    end
    

    add_index(:members, [:name, :phone])
    add_index(:sales, [:store_id, :member_id])
    add_index(:sale_details, :product_id)
    add_index(:transfers, [:from_store_id, :to_store_id])
    add_index(:orders, [:store_id, :product_id ])
  end
end
