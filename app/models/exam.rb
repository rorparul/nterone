# == Schema Information
#
# Table name: exams
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  platform_id    :integer
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#  archived       :boolean          default(FALSE)
#
# Indexes
#
#  index_exams_on_origin_region  (origin_region)
#

class Exam < ActiveRecord::Base
  include Regions

  belongs_to :platform

  has_many :exam_dynamics,            dependent: :destroy
  has_many :exam_and_course_dynamics, through: :exam_dynamics
  has_many :passed_exams,             dependent: :restrict_with_error
  has_many :users,                    through: :passed_exams

  validates :title, presence: true

  after_initialize :set_all_regions, if: :new_record?
end
