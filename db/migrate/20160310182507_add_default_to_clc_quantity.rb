class AddDefaultToClcQuantity < ActiveRecord::Migration
  def change
    change_column_default :orders, :clc_quantity, 0
  end
end
