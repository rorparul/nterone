class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.belongs_to :video_module
      t.string     :title
      t.string     :url
      t.text       :embed_code
      t.boolean    :free
      t.timestamps null: false
    end
  end
end
