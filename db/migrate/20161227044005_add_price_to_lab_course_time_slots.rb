class AddPriceToLabCourseTimeSlots < ActiveRecord::Migration
  def change
    add_column :lab_course_time_blocks, :price, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
