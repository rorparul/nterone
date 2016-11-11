class AddMetaDescriptionToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :meta_description, :string
  end
end
