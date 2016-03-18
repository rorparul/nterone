class AddCompanyToAddressFields < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_company, :string
    add_column :orders, :billing_company,  :string
    add_column :users,  :shipping_company, :string
    add_column :users,  :billing_company,  :string
  end
end
