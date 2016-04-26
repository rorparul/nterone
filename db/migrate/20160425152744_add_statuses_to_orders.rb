class AddStatusesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :verified, :boolean, default: false
    add_column :orders, :invoiced, :boolean, default: false
  end
end
