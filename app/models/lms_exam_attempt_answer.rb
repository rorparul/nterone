# == Schema Information
#
# Table name: lms_exam_attempt_answers
#
#  id                   :integer          not null, primary key
#  lms_exam_attempt_id  :integer
#  lms_exam_question_id :integer
#  lms_exam_answer_id   :integer
#  answer_text          :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  position             :integer
#  origin_region        :integer
#  active_regions       :text             default([]), is an Array
#
# Indexes
#
#  index_lms_exam_attempt_answers_on_lms_exam_answer_id    (lms_exam_answer_id)
#  index_lms_exam_attempt_answers_on_lms_exam_attempt_id   (lms_exam_attempt_id)
#  index_lms_exam_attempt_answers_on_lms_exam_question_id  (lms_exam_question_id)
#
# Foreign Keys
#
#  fk_rails_0d79488b8f  (lms_exam_question_id => lms_exam_questions.id)
#  fk_rails_35a6d2df9d  (lms_exam_answer_id => lms_exam_answers.id)
#  fk_rails_a2a48529d4  (lms_exam_attempt_id => lms_exam_attempts.id)
#

class LmsExamAttemptAnswer < ActiveRecord::Base
  include Regions

  belongs_to :lms_exam_attempt
  belongs_to :lms_exam_question
  belongs_to :lms_exam_answer

  def correct_answer
    lms_exam_question.lms_exam_answers.where(correct: true)
  end

  def correct?
    if lms_exam_question.free_form?
      return answer_text.downcase == lms_exam_answer.answer_text.downcase
    end

    if lms_exam_question.multiple_choice?
      return lms_exam_answer.correct
    end

    if lms_exam_question.correct_order?
      return correct_order_correct?
    end
  end

  private

  def correct_order_correct?
    result = true

    self.answer_text.split(',').each do |answer|
      id = answer.split(':').first.to_i
      position = answer.split(':').second.to_i
      result = false if LmsExamAnswer.find(id).position != position
    end

    return result
  end
end
