class AddTasksToEvents < ActiveRecord::Migration
  def change
    add_column :events, :sent_webex_invite,    :boolean, default: false
    add_column :events, :sent_course_material, :boolean, default: false
    add_column :events, :sent_lab_credentials, :boolean, default: false
  end
end
