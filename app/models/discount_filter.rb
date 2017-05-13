# == Schema Information
#
# Table name: discount_filters
#
#  id                :integer          not null, primary key
#  discount_id       :integer
#  event             :boolean
#  vod               :boolean
#  event_format      :string
#  event_guaranteed  :boolean
#  event_course_id   :integer
#  event_city        :string
#  event_state       :string
#  event_partner_led :boolean
#  event_language    :integer
#  vod_platform_id   :integer
#  vod_partner_led   :boolean
#  vod_lms           :boolean
#  origin_region     :integer
#  active_regions    :text             default([]), is an Array
#

class DiscountFilter < ActiveRecord::Base
  include Regions

  belongs_to :discount
end
