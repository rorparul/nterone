module GeneralHelper
  def personal_greeting
    personal_greeting = "Guest"
    if user_signed_in?
      if current_user.first_name.present?
        personal_greeting = current_user.first_name
      else
        if current_user.admin?
          personal_greeting = "Admin"
        elsif current_user.sales?
          personal_greeting = "Sales"
        else
          personal_greeting = "Member"
        end
      end
    end
    "<span>Welcome<br>#{personal_greeting}<span/>".html_safe
  end

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
