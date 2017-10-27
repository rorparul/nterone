# == Schema Information
#
# Table name: subscriptions
#
#  id                 :integer          not null, primary key
#  date_exp           :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  video_on_demand_id :integer
#  origin_region      :integer
#  active_regions     :text             default([]), is an Array
#
# Indexes
#
#  index_subscriptions_on_origin_region  (origin_region)
#

class Subscription < ActiveRecord::Base
  include Regions

  belongs_to :video_on_demand

  has_one :order_item, as: :orderable
  has_one :order,      through: :order_item
end
