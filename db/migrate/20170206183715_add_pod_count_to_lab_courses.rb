class AddPodCountToLabCourses < ActiveRecord::Migration
  def change
    add_column :lab_courses, :pods_individual, :integer
    add_column :lab_courses, :pods_partner, :integer
  end
end
