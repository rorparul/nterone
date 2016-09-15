class CreateLabCourses < ActiveRecord::Migration
  def change
    create_table :lab_courses do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
