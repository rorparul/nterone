class CreateVideoModules < ActiveRecord::Migration
  def change
    create_table :video_modules do |t|
      t.belongs_to :video_on_demand
      t.string :title
      t.timestamps null: false
    end
  end
end
