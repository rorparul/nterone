class AddBillingNameToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :billing_first_name, :string
    add_column :orders, :billing_last_name,  :string
  end
end
