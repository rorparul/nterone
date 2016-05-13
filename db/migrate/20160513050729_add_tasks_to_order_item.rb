class AddTasksToOrderItem < ActiveRecord::Migration
  def change
    add_column :order_items, :sent_webex_invite,    :boolean, default: false
    add_column :order_items, :sent_course_material, :boolean, default: false
    add_column :order_items, :sent_lab_credentials, :boolean, default: false

    rename_column :events, :sent_webex_invite,    :sent_all_webex_invite
    rename_column :events, :sent_course_material, :sent_all_course_material
    rename_column :events, :sent_lab_credentials, :sent_all_lab_credentials
  end
end
