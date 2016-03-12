class ChangeClcColumn3 < ActiveRecord::Migration
  def change
    change_column :orders, :clc_quantity, :integer, null: true, default: 0
  end
end
