class AddPartnerLedToEvent < ActiveRecord::Migration
  def change
    add_column :events, :partner_led, :boolean, default: false
  end
end
