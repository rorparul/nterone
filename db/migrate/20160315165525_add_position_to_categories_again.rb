class AddPositionToCategoriesAgain < ActiveRecord::Migration
  def change
    add_column :categories, :position, :integer, default: 0
  end
end
