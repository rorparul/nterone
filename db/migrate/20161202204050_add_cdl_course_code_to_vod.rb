class AddCdlCourseCodeToVod < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :cdl_course_code, :string
  end
end
