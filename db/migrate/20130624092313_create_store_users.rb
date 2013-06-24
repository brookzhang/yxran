class CreateStoreUsers < ActiveRecord::Migration
  def change
    create_table :store_users do |t|
      t.references :store
      t.references :user
      t.string :role

      t.timestamps
    end
  end
end
