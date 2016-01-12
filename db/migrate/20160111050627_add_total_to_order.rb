class AddTotalToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :paid, :decimal, precision: 8, scale: 2
  end
end
