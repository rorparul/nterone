# == Schema Information
#
# Table name: lms_exam_questions
#
#  id            :integer          not null, primary key
#  question_text :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  question_type :integer          default(0)
#

class LmsExamQuestion < ActiveRecord::Base
  enum question_type: {
    multiple_choice: 0,
    free_form: 1,
    correct_order: 2
  }

  has_many :lms_exam_question_joins
  has_many :lms_exams, through: :lms_exam_question_joins
  has_many :lms_exam_answers

  accepts_nested_attributes_for :lms_exam_answers, reject_if: :all_blank, allow_destroy: true
end
