class LmsExamAttemptAnswer < ActiveRecord::Base
  belongs_to :lms_exam_attempt
  belongs_to :lms_exam_question
  belongs_to :lms_exam_answer

  def correct_answer
    lms_exam_question.lms_exam_answers.where(correct: true)
  end

  def correct?
    if lms_exam_question.free_form?
      return answer_text == lms_exam_answer.try(:answer_text)
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
