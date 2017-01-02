class AddLabCourseTimeBlockIdToLabRentals < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :lab_course_time_block_id, :integer
  end
end
