class LmsStudentAssigmentPolicy < Struct.new(:user, :lms_student_assigment)
  def index?
    user.lms_manager?
  end
end
