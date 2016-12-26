class CreateLabRentalBlock < ActiveRecord::Migration
  def change
    create_table :lab_rental_blocks do |t|
      t.integer :units
      t.decimal :unit_price, precision: 8, scale: 2, default: 0.0
      t.date :date_start
      t.date :date_end
      t.time :time_start
      t.time :time_end
    end
  end
end
