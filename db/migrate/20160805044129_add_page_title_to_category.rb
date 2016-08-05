class AddPageTitleToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :page_title, :string
  end
end
