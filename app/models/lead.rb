class Lead < ActiveRecord::Base
  belongs_to :buyer,  class_name: "User"
  belongs_to :seller, class_name: "User"

  include PublicActivity::Common

  def regular_price
    view_context.formatted_price_or_range_of_my_plan_for(self.buyer)
  end

  def discounted_price
    self.regular_price * (1 - (self.discount.to_f / 100))
  end

  def planned_unattended_courses_titles
    self.buyer.planned_unattended_courses.collect { |course| course.title }
  end
end
