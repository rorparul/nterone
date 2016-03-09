class AddCourseAttributesToVods < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :intro, :text
    add_column :video_on_demands, :overview, :text
    add_column :video_on_demands, :outline, :text
    add_column :video_on_demands, :intended_audience, :text
  end
end
