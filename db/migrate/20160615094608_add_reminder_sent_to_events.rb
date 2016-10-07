class AddReminderSentToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reminder_sent, :boolean, default: false
  end
end
