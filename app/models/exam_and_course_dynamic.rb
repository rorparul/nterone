# == Schema Information
#
# Table name: exam_and_course_dynamics
#
#  id          :integer          not null, primary key
#  label       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  platform_id :integer
#

class ExamAndCourseDynamic < ActiveRecord::Base
  belongs_to :platform

  has_many :group_items,     as:        :groupable, dependent: :destroy
  has_many :exam_dynamics,   dependent: :destroy
  has_many :course_dynamics, dependent: :destroy
  has_many :exams,           through:   :exam_dynamics
  has_many :courses,         through:   :course_dynamics

  accepts_nested_attributes_for :exams,   reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :courses, reject_if: :all_blank, allow_destroy: true

  validates :label, :course_dynamics, :exam_dynamics, presence: true
end
