class AddCdlStuffToModules < ActiveRecord::Migration
  def change
    add_column :video_modules, :cisco_digital_learning, :boolean, default: false
    add_column :video_modules, :cdl_course_code, :string
  end
end
