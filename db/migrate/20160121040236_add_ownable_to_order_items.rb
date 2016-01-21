class AddOwnableToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :ownable_id,   :integer
    add_column :order_items, :ownable_type, :string
    add_index  :order_items, :ownable_id
    add_column :order_items, :seller_id, :integer
    add_column :order_items, :buyer_id,  :integer
    add_index :order_items, :seller_id
    add_index :order_items, :buyer_id
    add_column :orders, :seller_id, :integer
    add_column :orders, :buyer_id,  :integer
    add_index :orders, :seller_id
    add_index :orders, :buyer_id
  end
end
