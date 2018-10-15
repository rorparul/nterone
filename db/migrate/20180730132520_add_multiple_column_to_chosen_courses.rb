class AddMultipleColumnToChosenCourses < ActiveRecord::Migration
  def change
    add_column :chosen_courses, :audit_complete_by_user, :string
    add_column :chosen_courses, :completed_all_labs_by_user, :string
    add_column :chosen_courses, :met_with_course_director_by, :string
    add_column :chosen_courses, :audit_complete_by_date, :date
    add_column :chosen_courses, :completed_all_labs_by_date, :date
    add_column :chosen_courses, :met_with_course_director_by_date, :date
  end
end
