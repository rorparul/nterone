class LmsExamQuestion < ActiveRecord::Base
  enum question_type: [:true_false, :multiple_choice]

  has_many :lms_exam_question_joins
  has_many :lms_exams, through: :lms_exam_question_joins
  has_many :lms_exam_answers

  belongs_to :correct_answer, class_name: "LmsExamAnswer"
end
