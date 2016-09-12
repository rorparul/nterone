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
#

class Registration < ActiveRecord::Base
  belongs_to :event

  has_one :order_item, as: :orderable
  has_one :order,      through: :order_item
end
