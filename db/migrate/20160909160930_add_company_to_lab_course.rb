class AddCompanyToLabCourse < ActiveRecord::Migration
  def change
    add_column :lab_courses, :company_id, :integer
    drop_table :company_lab_courses
  end
end
