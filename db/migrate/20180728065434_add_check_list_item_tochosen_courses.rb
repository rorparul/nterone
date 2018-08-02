class AddCheckListItemTochosenCourses < ActiveRecord::Migration
  def change
    add_column :chosen_courses, :audit_complete, :boolean, default: false
    add_column :chosen_courses, :completed_all_labs, :boolean, default: false
    add_column :chosen_courses, :met_with_course_director, :boolean, default: false
  end
end
