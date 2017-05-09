class AddDescriptionToLabCourses < ActiveRecord::Migration
  def change
    add_column :lab_courses, :description, :text
  end
end
