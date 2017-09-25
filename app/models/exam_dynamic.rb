# == Schema Information
#
# Table name: exam_dynamics
#
#  id                         :integer          not null, primary key
#  exam_and_course_dynamic_id :integer
#  exam_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  origin_region              :integer
#  active_regions             :text             default([]), is an Array
#
# Indexes
#
#  index_exam_dynamics_on_origin_region  (origin_region)
#

class ExamDynamic < ActiveRecord::Base
  include Regions

  belongs_to :exam_and_course_dynamic
  belongs_to :exam

  validates :exam, presence: true
end
