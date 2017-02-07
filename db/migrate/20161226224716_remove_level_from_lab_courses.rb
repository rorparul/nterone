class RemoveLevelFromLabCourses < ActiveRecord::Migration
  def change
    remove_column :lab_courses, :level_individual
    remove_column :lab_courses, :level_partner
  end
end
