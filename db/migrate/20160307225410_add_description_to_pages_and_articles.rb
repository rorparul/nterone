class AddDescriptionToPagesAndArticles < ActiveRecord::Migration
  def change
    add_column :pages,             :page_description, :text
    add_column :blog_posts,        :page_description, :text
    add_column :press_releases,    :page_description, :text
    add_column :industry_articles, :page_description, :text
  end
end
