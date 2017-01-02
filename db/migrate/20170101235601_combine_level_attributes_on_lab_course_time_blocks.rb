class CombineLevelAttributesOnLabCourseTimeBlocks < ActiveRecord::Migration
  def change
    remove_column :lab_course_time_blocks, :level_partner
    remove_column :lab_course_time_blocks, :level_individual
    add_column :lab_course_time_blocks, :level, :string
  end
end
