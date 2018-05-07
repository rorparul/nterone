class RemoveUnusedSchemaElements < ActiveRecord::Migration
  def change
    drop_table :active_admin_comments
    drop_table :announcements
    drop_table :messages
    drop_table :bootsy_image_galleries
    drop_table :bootsy_images
    drop_table :carousel_items
    drop_table :image_store_units
  end
end
