class AddPositionToCategoriesMain < ActiveRecord::Migration
  def change
    add_column :categories, :position_as_parent, :integer, default: 0
    add_column :categories, :position_as_child,  :integer, default: 0
  end
end
