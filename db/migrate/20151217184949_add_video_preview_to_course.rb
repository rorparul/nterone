class AddVideoPreviewToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :video_preview, :text
  end
end
