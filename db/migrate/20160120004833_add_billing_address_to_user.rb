class AddBillingAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :billing_street,   :string
    add_column :users, :billing_city,     :string
    add_column :users, :billing_state,    :string
    add_column :users, :billing_zip_code, :string
  end
end
