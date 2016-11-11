class LmsExamAttempt < ActiveRecord::Base
  belongs_to :lms_exam
  belongs_to :user

  has_many :lms_exam_attempt_answers, dependent: :destroy

  def number_correct
    num_correct = 0

    lms_exam_attempt_answers.each do |attempt_answer|
      num_correct += 1 if attempt_answer.correct?
    end

    num_correct
  end

  def question_count
    self.lms_exam.lms_exam_questions.length
  end

  def percent_correct
    (self.number_correct * 100) / question_count
  end
end
