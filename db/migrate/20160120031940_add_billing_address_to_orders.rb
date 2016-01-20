class AddBillingAddressToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :billing_street, :string
    add_column :orders, :billing_city,   :string
    add_column :orders, :billing_state,  :string
  end
end
