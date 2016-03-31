class RemoveBootsyTables < ActiveRecord::Migration
  def change
    drop_table :bootsy_image_galleries
    drop_table :bootsy_images
    drop_table :industry_articles
    # drop_table :purchased_items
    drop_table :thredded_categories
    drop_table :thredded_images
    drop_table :thredded_messageboards
    drop_table :thredded_notification_preferences
    drop_table :thredded_post_notifications
    drop_table :thredded_posts
    drop_table :thredded_private_topics
    drop_table :thredded_private_users
    drop_table :thredded_roles
    drop_table :thredded_topic_categories
    drop_table :thredded_topics
    drop_table :thredded_user_details
    drop_table :thredded_user_preferences
    drop_table :topics
    drop_table :press_releases
    drop_table :forums
    drop_table :blog_posts
    drop_table :posts
    drop_table :carousel_items
  end
end
