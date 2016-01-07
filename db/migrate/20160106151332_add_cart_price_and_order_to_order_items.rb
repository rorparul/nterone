class AddCartPriceAndOrderToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :cart_id,  :integer
    add_column :order_items, :price,    :decimal
    add_column :order_items, :order_id, :integer
  end
end
