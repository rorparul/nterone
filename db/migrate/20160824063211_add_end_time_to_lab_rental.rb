class AddEndTimeToLabRental < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :end_time, :time
  end
end
