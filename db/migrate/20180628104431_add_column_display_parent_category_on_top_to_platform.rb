class AddColumnDisplayParentCategoryOnTopToPlatform < ActiveRecord::Migration
  def change
    add_column :platforms, :display_parent_category_on_top, :boolean, default: false
  end
end
