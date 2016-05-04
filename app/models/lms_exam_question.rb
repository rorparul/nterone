class LmsExamQuestion < ActiveRecord::Base
  enum question_type: [:true_false, :multiple_choice]

  has_many :lms_exam_question_joins
  has_many :lms_exams, through: :lms_exam_question_joins
  has_many :lms_exam_answers

  accepts_nested_attributes_for :lms_exam_answers, reject_if: :all_blank, allow_destroy: true
end
