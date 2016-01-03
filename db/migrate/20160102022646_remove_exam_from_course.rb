class RemoveExamFromCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :exam_id
  end
end
