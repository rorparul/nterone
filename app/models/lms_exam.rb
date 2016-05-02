class LmsExam < ActiveRecord::Base
  enum exam_type: [:quiz, :test]

  has_many :lms_exam_question_joins
  has_many :lms_exam_questions, through: :lms_exam_question_joins
end
