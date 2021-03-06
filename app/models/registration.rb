# == Schema Information
#
# Table name: registrations
#
#  id                   :integer          not null, primary key
#  sent_webex_invite    :boolean          default(FALSE)
#  sent_course_material :boolean          default(FALSE)
#  sent_lab_credentials :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  event_id             :integer
#  origin_region        :integer
#  active_regions       :text             default([]), is an Array
#
# Indexes
#
#  index_registrations_on_origin_region  (origin_region)
#

class Registration < ActiveRecord::Base
  include Regions

  belongs_to :event

  has_one :order_item, as: :orderable
  has_one :order,      through: :order_item
end
