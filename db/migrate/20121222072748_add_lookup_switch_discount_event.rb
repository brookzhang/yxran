class AddLookupSwitchDiscountEvent < ActiveRecord::Migration
  def change
    
    create_table(:lookups) do |t|
      t.string :code
      t.string :category
      t.string :description
      t.integer :sequence
      t.integer :status, :default => 1
      
      t.timestamps
    end
    
    
    create_table(:switches) do |t|
      t.string :key
      t.string :value
      t.string :description
      t.integer :status, :default => 1
      
      t.timestamps
    end
    
    create_table(:discounts) do |t|
      t.references :category
      t.integer :member_level
      t.float :discount
      
      t.timestamps
    end
    
    create_table(:events) do |t|
      t.string :category #lookup.code
      t.string :content
      t.references :user
      t.datetime :created_at
    end

    add_index(:lookups, [:code, :category])
    add_index(:switches, [:key, :value])
    add_index(:discounts, [:category_id, :member_level])
    add_index(:events, [:category, :user_id])
  end
end
