# == Schema Information
#
# Table name: category_courses
#
#  id          :integer          not null, primary key
#  category_id :integer
#  course_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CategoryCourse < ActiveRecord::Base
  belongs_to :category
  belongs_to :course

  validates :category_id, uniqueness: { scope: :course_id }
end
