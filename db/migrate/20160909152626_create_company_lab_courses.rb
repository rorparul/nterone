class CreateCompanyLabCourses < ActiveRecord::Migration
  def change
    create_table :company_lab_courses do |t|
      t.belongs_to :company
      t.belongs_to :lab_course
      t.timestamps null: false
    end

    remove_column :lab_courses, :company_id
  end
end
