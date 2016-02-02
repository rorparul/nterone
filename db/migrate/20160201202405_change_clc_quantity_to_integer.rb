class ChangeClcQuantityToInteger < ActiveRecord::Migration
  def change
    remove_column :orders, :clc_quantity
    add_column    :orders,  :clc_quantity, :integer
  end
end
