class LmsExamAttempt < ActiveRecord::Base
  belongs_to :lms_exam
  belongs_to :user

  has_many :lms_exam_attempt_answers

  def number_correct
    num_correct = 0

    lms_exam_attempt_answers.each do |attempt_answer|
      num_correct += 1 if attempt_answer.lms_exam_answer.correct
    end

    num_correct
  end
end
