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
  end
end
