class ChangeClcColumn2 < ActiveRecord::Migration
  def change
    change_column :orders, :clc_quantity, :integer, default: '0'
  end
end
