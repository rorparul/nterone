class CorrectTypoOnAbbreviationColumnOfLabCourses < ActiveRecord::Migration
  def change
    rename_column :lab_courses, :abbreviaton, :abbreviation
  end
end
