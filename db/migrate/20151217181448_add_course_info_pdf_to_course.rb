class AddCourseInfoPdfToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :course_info, :string
  end
end
