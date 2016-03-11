class AddPartnerLedToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :partner_led, :boolean, default: false
  end
end
