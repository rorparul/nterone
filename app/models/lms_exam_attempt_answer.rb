class LmsExamAttemptAnswer < ActiveRecord::Base
  belongs_to :lms_exam_attempt
  belongs_to :lms_exam_question
  belongs_to :lms_exam_answer

  def correct_answer
    lms_exam_question.lms_exam_answers.where(correct: true)
  end
end
