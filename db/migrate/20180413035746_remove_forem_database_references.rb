class RemoveForemDatabaseReferences < ActiveRecord::Migration
  def change
    remove_column :users,  :forem_admin,          :boolean
    remove_column :users,  :forem_state,          :string
    remove_column :users,  :forem_auto_subscribe, :boolean
    remove_column :guests, :forem_admin,          :boolean
    remove_column :guests, :forem_state,          :string
    remove_column :guests, :forem_auto_subscribe, :boolean

    drop_table :forem_categories
    drop_table :forem_forums
    drop_table :forem_groups
    drop_table :forem_memberships
    drop_table :forem_moderator_groups
    drop_table :forem_posts
    drop_table :forem_subscriptions
    drop_table :forem_topics
    drop_table :forem_views
  end
end
