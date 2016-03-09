class AddTypeToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :kind, :string
  end
end
