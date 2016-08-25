class AddLabCourseIdToLabRental < ActiveRecord::Migration
  def change
    add_reference :lab_rentals, :lab_course, index: true, foreign_key: true
  end
end
