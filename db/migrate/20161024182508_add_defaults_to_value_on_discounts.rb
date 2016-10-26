class AddDefaultsToValueOnDiscounts < ActiveRecord::Migration
  def change
    change_column :discounts, :value, :integer, precision: 8, scale: 2, default: 0.0
  end
end
