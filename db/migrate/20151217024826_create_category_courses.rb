class CreateCategoryCourses < ActiveRecord::Migration
  def change
    create_table :category_courses do |t|
      t.belongs_to :category
      t.belongs_to :course
      t.timestamps null: false
    end
  end
end
