class AddCart < ActiveRecord::Migration
  def change
    create_table(:carts) do |t|
      t.references :product
      t.references :store
      t.references :user
      t.integer :quantity
      t.float :used_score
      t.float :amount
      
      t.timestamps
    end
    
    
  end
end
