class AddDoNotSendInstructorEmailToEvent < ActiveRecord::Migration
  def change
    add_column :events, :do_not_send_instructor_email, :boolean, default: false
  end
end
