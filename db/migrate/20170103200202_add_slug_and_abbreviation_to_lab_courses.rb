class AddSlugAndAbbreviationToLabCourses < ActiveRecord::Migration
  def change
    add_column :lab_courses, :slug, :string
    add_column :lab_courses, :abbreviaton, :string
  end
end
