class AddNewFieldsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :gilmore_order_number, :string
    add_column :orders, :gilmore_invoice, :string
    add_column :orders, :royalty_id, :string
    add_column :orders, :closed_date, :date
  end
end
