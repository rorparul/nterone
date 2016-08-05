class AddHeadingToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :heading, :string
  end
end
