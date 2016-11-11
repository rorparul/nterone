# == Schema Information
#
# Table name: lms_exam_answers
#
#  id                   :integer          not null, primary key
#  answer_text          :text
#  lms_exam_question_id :integer
#  position             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  correct              :boolean          default(FALSE)
#
# Indexes
#
#  index_lms_exam_answers_on_lms_exam_question_id  (lms_exam_question_id)
#
# Foreign Keys
#
#  fk_rails_8ced3d0303  (lms_exam_question_id => lms_exam_questions.id)
#

class LmsExamAnswer < ActiveRecord::Base
  belongs_to :lms_exam_question
end
