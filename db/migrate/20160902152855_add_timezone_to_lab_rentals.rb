class AddTimezoneToLabRentals < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :time_zone, :string
  end
end
