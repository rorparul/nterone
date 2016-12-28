class AddLevelToLabCourseTimeBlocks < ActiveRecord::Migration
  def change
    add_column :lab_course_time_blocks, :level_individual, :boolean
    add_column :lab_course_time_blocks, :level_partner, :boolean
  end
end
