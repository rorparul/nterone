# == Schema Information
#
# Table name: subscriptions
#
#  id                 :integer          not null, primary key
#  date_exp           :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  video_on_demand_id :integer
#

class Subscription < ActiveRecord::Base
  belongs_to :video_on_demand

  has_one :order_item, as: :orderable
  has_one :order,      through: :order_item
end
