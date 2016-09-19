class AddLastDayToLabRentals < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :last_day, :date
  end
end
