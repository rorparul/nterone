class RemoveSubjectFromCourse < ActiveRecord::Migration
  def change
    remove_column :chosen_courses, :planned_subject_id
  end
end
