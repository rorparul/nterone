class CiscoCourseProductCodeToVod < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :cisco_course_product_code, :string
  end
end
