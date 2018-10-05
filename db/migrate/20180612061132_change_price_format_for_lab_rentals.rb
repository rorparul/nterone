class ChangePriceFormatForLabRentals < ActiveRecord::Migration
  def change
    change_column :lab_rentals, :price, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
