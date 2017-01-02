class RemoveLabCourseTimeBlockIdFromLabRentals < ActiveRecord::Migration
  def change
    remove_column :lab_rentals, :lab_course_time_block_id
  end
end
