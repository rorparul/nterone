class CreateCategoryVideoOnDemands < ActiveRecord::Migration
  def change
    create_table :category_video_on_demands do |t|
      t.belongs_to :category
      t.belongs_to :video_on_demand
      t.timestamps null: false
    end
  end
end
