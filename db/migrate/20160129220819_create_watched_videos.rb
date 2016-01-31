class CreateWatchedVideos < ActiveRecord::Migration
  def change
    create_table :watched_videos do |t|
      t.belongs_to :user
      t.belongs_to :video
      t.string     :status
      t.timestamps null: false
    end
  end
end
