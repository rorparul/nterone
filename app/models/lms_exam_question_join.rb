# == Schema Information
#
# Table name: lms_exam_question_joins
#
#  id                   :integer          not null, primary key
#  lms_exam_id          :integer
#  lms_exam_question_id :integer
#  position             :integer
#  active               :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_lms_exam_question_joins_on_lms_exam_id           (lms_exam_id)
#  index_lms_exam_question_joins_on_lms_exam_question_id  (lms_exam_question_id)
#
# Foreign Keys
#
#  fk_rails_6bd82c01fc  (lms_exam_id => lms_exams.id)
#  fk_rails_7716feb102  (lms_exam_question_id => lms_exam_questions.id)
#

class LmsExamQuestionJoin < ActiveRecord::Base
  belongs_to :lms_exam
  belongs_to :lms_exam_question
end
