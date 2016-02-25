class AddSlugs < ActiveRecord::Migration
  def change
    add_column :pages,             :slug, :string
    add_column :press_releases,    :slug, :string
    add_column :blog_posts,        :slug, :string
    add_column :industry_articles, :slug, :string
  end
end
