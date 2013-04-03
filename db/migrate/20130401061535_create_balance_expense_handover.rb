class CreateBalanceExpenseHandover < ActiveRecord::Migration
  def change
    create_table(:balances) do |t|
      t.references :store
      t.references :user
      t.string :category
      t.integer :reference_id
      t.float :amount
      
      t.timestamps
    end
    
    create_table(:expenses) do |t|
      t.references :store
      t.references :user
      t.string :category
      t.float :amount
      t.string :remark
      
      t.timestamps
    end
    
    create_table(:handovers) do |t|
      t.references :store
      t.references :user
      t.string :status
      t.float :take_amount
      t.float :hand_amount
      t.string :take_remark
      t.string :hand_remark
      t.datetime :took_at
      t.datetime :handed_at
      
    end
    

    add_index(:balances, [:store_id, :user_id, :reference_id])
    add_index(:expenses, [:store_id, :user_id])
    add_index(:handovers, [:store_id, :user_id ])
  end
end
