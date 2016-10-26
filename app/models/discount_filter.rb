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
#

class DiscountFilter < ActiveRecord::Base
  belongs_to :discount
end
