class LmsStudentCoursePolicy < Struct.new(:user, :lms_student_course)
  def show?
    user.lms_manager?
  end
end
