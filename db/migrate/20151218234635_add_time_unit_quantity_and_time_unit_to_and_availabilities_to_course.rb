class AddTimeUnitQuantityAndTimeUnitToAndAvailabilitiesToCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :length
    add_column    :courses, :time_unit_quantity, :integer
    add_column    :courses, :time_unit, :string
    add_column    :courses, :availabilities, :string
  end
end
