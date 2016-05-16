module QuizHelper
  def passed_exam(user, exam)
    user.passed_exams.any? do |passed_exam|
      passed_exam.exam == exam
    end
  end

  def taken_exam_status(user, lms_exam)
    return if !user

    if lms_exam.completed_by?(user)
      "<span class='status-circle completed' />".html_safe
    elsif LmsExamAttempt.exists?(user: user, lms_exam: lms_exam)
      "<span class='status-circle started' />".html_safe
    else
      "<span class='status-circle' />".html_safe
    end
  end
end
