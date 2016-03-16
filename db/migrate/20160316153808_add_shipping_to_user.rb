class AddShippingToUser < ActiveRecord::Migration
  def change
    add_column :users, :shipping_first_name, :string
    add_column :users, :shipping_last_name,  :string
    add_column :users, :shipping_street,     :string
    add_column :users, :shipping_city,       :string
    add_column :users, :shipping_state,      :string
    add_column :users, :shipping_zip_code,   :string
  end
end
