class AddBillingAttributesToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :waiting, :boolean, default: false
    add_column :opportunities, :payment_kind, :string
    add_column :opportunities, :billing_street, :string
    add_column :opportunities, :billing_city, :string
    add_column :opportunities, :billing_state, :string
    add_column :opportunities, :billing_zip_code, :string
  end
end
