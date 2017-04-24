class AddTheaterToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :theater, :integer
  end
end
