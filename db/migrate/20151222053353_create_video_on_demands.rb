class CreateVideoOnDemands < ActiveRecord::Migration
  def change
    create_table :video_on_demands do |t|
      t.belongs_to :course
      t.belongs_to :instructor
      t.string     :level
      t.integer    :price
      t.timestamps null: false
    end
  end
end
