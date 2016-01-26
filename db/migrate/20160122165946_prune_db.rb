class PruneDb < ActiveRecord::Migration
  def change
    change_column :courses, :price, :decimal, precision: 8, scale: 2, default: 0.0
    remove_column :courses, :sku
    rename_column :courses, :course_info, :pdf
    remove_column :courses, :url
    change_column :events,  :price, :decimal, precision: 8, scale: 2, default: 0.0
    remove_column :order_items, :ownable_id
    remove_column :order_items, :ownable_type
    remove_column :order_items, :seller_id
    remove_column :order_items, :buyer_id
    change_column :order_items, :price, :decimal, precision: 8, scale: 2, default: 0.0
    # remove_index  :order_items, :seller_id
    # remove_index  :order_items, :buyer_id
    # remove_index  :order_items, :ownable_id
    rename_column :orders, :street, :shipping_street
    rename_column :orders, :city, :shipping_city
    rename_column :orders, :state, :shipping_state
    rename_column :orders, :postal_code, :shipping_zip_code
    rename_column :orders, :country, :shipping_country
    add_column    :orders, :billing_country, :string
    remove_column :orders, :user_id
    rename_column :orders, :name_on_card, :billing_name
    add_column    :orders, :payment_type, :string
    drop_table    :user_events
    drop_table    :user_vods
    remove_column :users, :admin
    remove_column :users, :gender
  end
end
