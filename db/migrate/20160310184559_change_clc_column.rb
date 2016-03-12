class ChangeClcColumn < ActiveRecord::Migration
  def change
    change_column :orders, :clc_quantity, :integer, null: false, default: 0
  end
end
