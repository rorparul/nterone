class AddCreditsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :clc_number,   :string
    add_column :orders, :clc_quantity, :string
  end
end
