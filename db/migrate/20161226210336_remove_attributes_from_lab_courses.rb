class RemoveAttributesFromLabCourses < ActiveRecord::Migration
  def change
    remove_column :lab_courses, :unit_price
    remove_column :lab_courses, :time_blocks
    remove_column :lab_courses, :date_start
    remove_column :lab_courses, :date_end
    remove_column :lab_courses, :time_start
    remove_column :lab_courses, :time_end
    remove_column :lab_courses, :ratio
  end
end
