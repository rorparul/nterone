class ChangeMetaDescriptionToCategory < ActiveRecord::Migration
  def change
    change_column :categories, :meta_description, :text
  end
end
