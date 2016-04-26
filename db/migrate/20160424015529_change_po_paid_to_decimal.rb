class ChangePoPaidToDecimal < ActiveRecord::Migration
  def change
    remove_column :orders, :po_paid
    add_column    :orders, :po_paid, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
