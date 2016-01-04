class Exam < ActiveRecord::Base
  belongs_to :platform

  has_many :exam_dynamics,            dependent: :destroy
  has_many :exam_and_course_dynamics, through: :exam_dynamics
  has_many :passed_exams,             dependent: :restrict_with_error
  has_many :users,                    through: :passed_exams

  validates :title, presence: true
end
