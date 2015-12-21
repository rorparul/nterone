class RemoveAllBrandReferencesFromSchema < ActiveRecord::Migration
  def change
    remove_column :announcements, :brand_id
    drop_table    :brand_favicons
    drop_table    :brands
    remove_column :forums, :brand_id
    remove_column :leads, :brand_id
    remove_column :platforms, :brand_id
    remove_column :roles, :brand_id
    drop_table    :visual_assets
  end
end
