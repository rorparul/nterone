class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.boolean :sent_webex_invite,    default: false
      t.boolean :sent_course_material, default: false
      t.boolean :sent_lab_credentials, default: false
      t.timestamps null: false
    end
  end
end
