class LmsExamAttempt < ActiveRecord::Base
  belongs_to :lms_exam
  belongs_to :user

  has_many :lms_exam_attempt_answers
end
