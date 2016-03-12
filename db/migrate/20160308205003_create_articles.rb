class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :page_title
      t.text   :page_description
      t.text   :content
      t.string :slug
      t.timestamps null: false
    end
  end
end
