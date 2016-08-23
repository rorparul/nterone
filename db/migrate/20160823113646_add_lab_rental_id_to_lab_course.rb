class AddLabRentalIdToLabCourse < ActiveRecord::Migration
  def change
    add_reference :lab_courses, :lab_rental, index: true, foreign_key: true
  end
end
