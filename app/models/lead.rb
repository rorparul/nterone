class Lead < ActiveRecord::Base
  belongs_to :brand
  belongs_to :buyer,  class_name: "User"
  belongs_to :seller, class_name: "User"

  include PublicActivity::Common

  def regular_price
    self.buyer.my_plan_grand_total
  end

  def discounted_price
    self.regular_price * (1 - (self.discount.to_f / 100))
  end

  def planned_unattended_courses_titles
    self.buyer.planned_unattended_courses.collect { |course| course.title }
  end
end
