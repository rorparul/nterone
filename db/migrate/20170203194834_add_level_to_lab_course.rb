class AddLevelToLabCourse < ActiveRecord::Migration
  def change
    add_column :lab_courses, :level, :string, default: 'both'
  end
end
