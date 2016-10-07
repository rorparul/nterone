class AddRemindersToEvent < ActiveRecord::Migration
  def change
    add_column :events, :should_remind, :boolean, default: true
    add_column :events, :remind_period, :integer, default: 0
  end
end
