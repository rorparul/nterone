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
# Indexes
#
#  index_discount_filters_on_origin_region  (origin_region)
#

class DiscountFilter < ActiveRecord::Base
  include Regions

  belongs_to :discount

  after_initialize :set_all_regions, if: :new_record?
end
