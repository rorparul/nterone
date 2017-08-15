# == Schema Information
#
# Table name: category_courses
#
#  id             :integer          not null, primary key
#  category_id    :integer
#  course_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#

class CategoryCourse < ActiveRecord::Base
  include Regions

  belongs_to :category
  belongs_to :course

  validates :category_id, uniqueness: { scope: :course_id }
end
