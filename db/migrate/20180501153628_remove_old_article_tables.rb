class RemoveOldArticleTables < ActiveRecord::Migration
  def change
    drop_table :press_releases
    drop_table :blog_posts
    drop_table :industry_articles
  end
end
