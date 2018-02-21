class DefaultRemindStudentsToFalse < ActiveRecord::Migration
  def change
    change_column :events, :should_remind, :boolean, default: false
  end
end
