class AddVideoBioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :video_bio, :text
  end
end
