class AddForeignIdsToRegistrationsAndSubscriptions < ActiveRecord::Migration
  def change
    add_column :registrations, :event_id,            :integer
    add_column :subscriptions, :video_on_demands_id, :integer
  end
end
