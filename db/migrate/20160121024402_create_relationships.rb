class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :seller_id
      t.integer :buyer_id
      t.string  :status
      t.timestamps null: false
    end
    add_index :relationships, :seller_id
    add_index :relationships, :buyer_id
    add_index :relationships, [:seller_id, :buyer_id], unique: true
  end
end
