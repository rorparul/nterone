class CreateImageStoreUnits < ActiveRecord::Migration
  def change
    create_table :image_store_units do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
