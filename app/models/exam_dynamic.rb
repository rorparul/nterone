# == Schema Information
#
# Table name: exam_dynamics
#
#  id                         :integer          not null, primary key
#  exam_and_course_dynamic_id :integer
#  exam_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class ExamDynamic < ActiveRecord::Base
  belongs_to :exam_and_course_dynamic
  belongs_to :exam

  validates :exam, presence: true
end
