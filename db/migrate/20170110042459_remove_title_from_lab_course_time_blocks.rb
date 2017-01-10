class RemoveTitleFromLabCourseTimeBlocks < ActiveRecord::Migration
  def change
    remove_column :lab_course_time_blocks, :title
  end
end
