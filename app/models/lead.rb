# == Schema Information
#
# Table name: leads
#
#  id            :integer          not null, primary key
#  seller_id     :integer
#  buyer_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :string           default("unassigned")
#  discount      :string           default("0")
#  origin_region :integer
#

class Lead < ActiveRecord::Base
  belongs_to :buyer,  class_name: "User"
  belongs_to :seller, class_name: "User"

  include PublicActivity::Common
  include Regions

  validates :buyer_id, presence: true

  def regular_price
    ApplicationController.helpers.formatted_price_or_range_of_my_plan_for(self.buyer)
  end

  def discounted_price
    self.regular_price * (1 - (self.discount.to_f / 100))
  end

  def planned_unattended_courses_titles
    self.buyer.planned_unattended_courses.collect { |course| course.title }
  end
end
