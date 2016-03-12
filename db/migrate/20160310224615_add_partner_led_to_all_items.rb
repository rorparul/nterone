class AddPartnerLedToAllItems < ActiveRecord::Migration
  def change
    add_column :subjects, :partner_led, :boolean, default: false
    add_column :video_on_demands, :partner_led, :boolean, default: false
  end
end
