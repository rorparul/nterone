# == Schema Information
#
# Table name: course_dynamics
#
#  id                         :integer          not null, primary key
#  exam_and_course_dynamic_id :integer
#  course_id                  :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  origin_region              :integer
#

class CourseDynamic < ActiveRecord::Base
  include Regions

  belongs_to :exam_and_course_dynamic
  belongs_to :course

  validates :course, presence: true
end
