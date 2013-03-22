class AddCart < ActiveRecord::Migration
  def change
    create_table(:carts) do |t|
      t.references :product
      t.references :store
      t.references :user
      t.integer :quantity
      t.float :unit_price
      t.float :amount
      t.float :discount
      t.float :score
      
      t.timestamps
    end
    
    
  end
end
