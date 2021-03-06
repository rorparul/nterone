# == Schema Information
#
# Table name: settings
#
#  id             :integer          not null, primary key
#  var            :string           not null
#  value          :text
#  thing_id       :integer
#  thing_type     :string(30)
#  created_at     :datetime
#  updated_at     :datetime
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_settings_on_origin_region                    (origin_region)
#  index_settings_on_thing_type_and_thing_id_and_var  (thing_type,thing_id,var) UNIQUE
#

# RailsSettings Model
class Setting < RailsSettings::Base
  # include Regions

  source Rails.root.join("config/app.yml")
  # cache_prefix { "v1" }

  def self.host
    "nterone.#{`hostname`.match(/\w+$/).to_s}"
  end
end
