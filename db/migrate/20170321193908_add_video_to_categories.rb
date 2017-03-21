class AddVideoToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :video, :text
  end
end
