class LmsExamAttemptAnswer < ActiveRecord::Base
  belongs_to :lms_exam_attempt
  belongs_to :lms_exam_question
  belongs_to :lms_exam_answer
end
