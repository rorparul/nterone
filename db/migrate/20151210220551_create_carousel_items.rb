class CreateCarouselItems < ActiveRecord::Migration
  def change
    create_table :carousel_items do |t|
      t.string :caption
      t.string :status
      t.timestamps null: false
    end
  end
end
