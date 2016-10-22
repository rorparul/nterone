class CreateDiscountCriteria < ActiveRecord::Migration
  def change
    create_table :discount_criteria do |t|
      t.integer :discount_id
      t.boolean :event
      t.boolean :vod
      t.string :event_format
      t.boolean :event_guaranteed
      t.integer :event_course_id
      t.string :event_city
      t.string :event_state
      t.boolean :event_partner_led
      t.integer :event_language
      t.integer :vod_platform_id
      t.boolean :vod_partner_led
      t.boolean :vod_lms
    end
  end
end
