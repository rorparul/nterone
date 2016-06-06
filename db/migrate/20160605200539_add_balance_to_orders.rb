class AddBalanceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :balance, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
