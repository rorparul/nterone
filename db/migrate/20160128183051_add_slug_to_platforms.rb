class AddSlugToPlatforms < ActiveRecord::Migration
  def change
    add_column :platforms, :slug, :string
  end
end
