class Add24HourToLab < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :twenty_four_hours, :boolean
  end
end
