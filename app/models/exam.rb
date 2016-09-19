# == Schema Information
#
# Table name: exams
#
#  id          :integer          not null, primary key
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  platform_id :integer
#

class Exam < ActiveRecord::Base
  belongs_to :platform

  has_many :exam_dynamics,            dependent: :destroy
  has_many :exam_and_course_dynamics, through: :exam_dynamics
  has_many :passed_exams,             dependent: :restrict_with_error
  has_many :users,                    through: :passed_exams

  validates :title, presence: true
end
