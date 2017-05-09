class AddCardDescriptionToLabCourses < ActiveRecord::Migration
  def change
    add_column :lab_courses, :card_description, :text
  end
end
