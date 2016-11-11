class LmsStudentCoursePolicy < Struct.new(:user, :lms_student_course)
  def show?
    user.lms_student? || user.lms_manager? || user.lms_business?
  end
end
