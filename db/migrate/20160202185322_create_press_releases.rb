class CreatePressReleases < ActiveRecord::Migration
  def change
    create_table :press_releases do |t|
      t.string :page_title
      t.string :title
      t.text   :content
      t.timestamps null: false
    end
  end
end
