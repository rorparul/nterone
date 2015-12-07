module GeneralHelper
  def planned_course(user, course)
    user.chosen_courses.where(planned: true).any? do |chosen_course|
      chosen_course.course == course
    end
  end

  def attended_course(user, course)
    user.chosen_courses.where(attended: true).any? do |chosen_course|
      chosen_course.course == course
    end
  end

  def passed_exam(user, exam)
    user.passed_exams.any? do |passed_exam|
      passed_exam.exam == exam
    end
  end
end
