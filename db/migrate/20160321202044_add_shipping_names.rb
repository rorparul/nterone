class AddShippingNames < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_first_name, :string
    add_column :orders, :shipping_last_name,  :string
  end
end
