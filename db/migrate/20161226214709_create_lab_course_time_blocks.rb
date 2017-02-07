class CreateLabCourseTimeBlocks < ActiveRecord::Migration
  def change
    create_table :lab_course_time_blocks do |t|
      t.integer :lab_course_id
      t.string :title
      t.decimal :unit_size, precision: 4, scale: 2, default: 1.0
      t.integer :unit_quantity
      t.integer :ratio, default: 1
    end
  end
end
