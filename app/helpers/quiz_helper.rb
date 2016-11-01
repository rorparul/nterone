module QuizHelper
  def passed_exam(user, exam)
    user.passed_exams.any? do |passed_exam|
      passed_exam.exam == exam
    end
  end

  def taken_exam_status(user, lms_exam)
    return if !user

    if lms_exam.completed_by?(user)
      "<span class='status-circle completed'/>".html_safe
    elsif LmsExamAttempt.exists?(user: user, lms_exam: lms_exam)
      "<span class='status-circle started'/>".html_safe
    else
      "<span class='status-circle'/>".html_safe
    end
  end

  def questions_for_react(questions)
    questions.map do |question|
      {
        id: question.id,
        text: question.question_text,
        type: question_type_mapping(question.question_type),
        answers: question.lms_exam_answers
      }
    end
  end

  private
  
  def question_type_mapping(type)
    return 0 if type == 'multiple_choice'
    return 1 if type == 'free_form'
    return 2 if type == 'correct_order'
  end
end
