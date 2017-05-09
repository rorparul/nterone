class AddAttributesToLabCourses < ActiveRecord::Migration
  def change
    add_column :lab_courses, :level_individual, :boolean
    add_column :lab_courses, :level_partner, :boolean
    add_column :lab_courses, :unit_price, :decimal, precision: 8, scale: 2, default: 0.0
    add_column :lab_courses, :time_blocks, :integer
    add_column :lab_courses, :date_start, :date
    add_column :lab_courses, :date_end, :date
    add_column :lab_courses, :time_start, :time
    add_column :lab_courses, :time_end, :time
    add_column :lab_courses, :ratio, :integer
  end
end
